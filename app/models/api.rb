class Api

  def self.build_stack_api_url(model, ids, **params)
    sites = model.underscore.split('_').map(&:pluralize)

    path = if ids
             ['', self.stack_api_version, sites.first, ids.join(';')]
           else
             ['', self.stack_api_version, sites.first]
           end
    path << sites.second if sites.size > 1
    path = path.join '/'

    query = params.map {|key, value| "#{key.to_s}=#{value.to_s}"}.join '&'

    URI::HTTPS.build([nil, self.stack_api_url, nil, path, query, nil])
  end

  private

  def self.stack_api_version
    $api[:version]
  end

  def self.stack_api_url
    $api[:url]
  end

end