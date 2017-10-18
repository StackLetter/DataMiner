class ApplicationJob < ActiveJob::Base

  def klass_error_msg
    '[Job Error]'
  end

  def available_token
    access_token = Account.available_token_accounts.first.try(:token)
    ErrorReporter.report(:error, nil, 'There is no ACCESS_TOKEN left!') unless access_token
    access_token
  end

  def next_token(old_token)
    Account.find_by(token: old_token).update(available_token: false)
    available_token
  end

end
