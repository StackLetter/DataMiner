class UserTagParserJob < GenericParserJob

  def perform(method = 'new', site_id = 1, user_ids, **query_params)
    chunk_size = 100 # max 100
    page_size = 100

    if method == 'new' || method == 'all'
      models_since = UserTag.order(created_at: :desc).limit(1).first
      models_since = (models_since && method == 'new') ? models_since.created_at.strftime('%s') : DateTime.new(1970).strftime('%s')

      unless user_ids&.empty?
        user_ids.each_slice(chunk_size) do |chunk|
          process_model_parsing('UserTag', chunk, page_size, site_id, query_params.merge(fromdate: models_since))
        end
      end
    end
  end

end