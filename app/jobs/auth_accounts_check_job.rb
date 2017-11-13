class AuthAccountsCheckJob < ApplicationJob

  def perform
    # max 20 access token on this route
    batch = 20

    Account.find_in_batches(batch_size: batch).each do |accounts|
      tokens = accounts.map(&:token)

      site_url = Api.build_stack_api_url('access-tokens', tokens, {key: ENV['SE_api_key'], pagesize: batch})

      begin
        response = JSON.parse RestClient.get(site_url.to_s)
      rescue Exception => e
        ErrorReporter.report(:error, e, "#{klass_error_msg} - AccessTokens(ids: #{accounts.map(&:id).to_s}) --- #{site_url.to_s}", response: response)
        raise
      end

      auth_tokens = {}
      response['items'].each {|item| auth_tokens[item['account_id']] = item['access_token']}

      to_delete = accounts.select {|account| auth_tokens[account.external_id].blank?}

      Account.transaction do
        to_delete.each do |account|
          User.where(account_id: account.id).update(account_id: nil)
          account.destroy
        end
      end

      sleep(response['backoff'].to_i + 1) if response['backoff']
    end
  end

end