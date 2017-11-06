class ApplicationController < ActionController::Base
  include TokenHelper

  protect_from_forgery with: :exception

  def klass_error_msg
    '[Controller Error]'
  end

  protected

  def filter_404_content(objects, site, type = 'Question', **query_params)
    access_token = available_token
    return ids unless access_token

    ids = objects.map(&:external_id)
    site_url = Api.build_stack_api_url(type, ids,
                                       {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: 100, page: 1, site: site.api, access_token: access_token}.merge(query_params))

    begin
      response = JSON.parse RestClient.get(site_url.to_s)
    rescue Exception => e
      ErrorReporter.report(:error, e, "#{klass_error_msg} - #{type}(ids: #{ids.to_s}) --- #{site_url.to_s}", response: response)
      raise
    end
    existing_ids = response['items'].map {|item| item["#{type.downcase}_id"]}
    (ids - existing_ids).each { |id| type.constantize.find_by(external_id: id, site_id: site.id)&.update(removed: true) }

    objects.select { |o| existing_ids.include? o.external_id }.map(&:id)
  end

end
