# == Schema Information
#
# Table name: user_favorites
#
#  id          :integer          not null, primary key
#  site_id     :integer
#  user_id     :integer
#  external_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserFavorite < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern
  include SiteIdScopedConcern

  belongs_to :user

  after_commit :question_exists?

  def self.process_json_items(items, site_id, ids = nil)
    self.transaction do
      items.each do |item|
        data = {}
        data['external_id'] = item['question_id']
        data['site_id'] = site_id
        data['user_id'] = User.find_by(external_id: ids&.first).id

        model = self.where(site_id: site_id).find_or_initialize_by(external_id: data['external_id'])

        model.assign_attributes(data)
        if model.valid?
          model.save
          model.update(data)
          self.initialize_tags(model, item['tags'], site_id) if model.respond_to?(:load_tags_after_parsing)
        else
          missing_models = model.errors.details.select {|_, detail| detail.select {|detail| [:not_specified, :blank].include?(detail[:error])}.size > 0}
          if missing_models.size > 0
            missing_models.keys.each do |object, _|

              missing_models_class_name = object.to_s.capitalize
              return if [item[object.to_s + '_id']].blank? || missing_models_class_name
              GenericParserJob.perform_later(SingleLevelStackApiModelConcern.name_map(missing_models_class_name.camelize, item['post_type']), [item[object.to_s + '_id'] || item['owner'].try(:[], 'user_id')], site_id)
            end
            GenericParserJob.perform_later(model.class.name, [model.external_id], site_id)
          end
        end

      end
    end
  end

  private

  def question_exists?
    GenericParserJob.perform_later('Question', [self.external_id], self.site_id) unless Question.exists?(external_id: self.external_id)
  end

end
