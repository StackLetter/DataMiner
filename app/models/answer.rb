# == Schema Information
#
# Table name: answers
#
#  id                   :integer          not null, primary key
#  external_id          :integer
#  site_id              :integer
#  up_vote_count        :integer
#  down_vote_count      :integer
#  owner_id             :integer
#  question_id          :integer
#  score                :integer
#  creation_date        :datetime
#  community_owned_date :datetime
#  last_activity_date   :datetime
#  locked_date          :datetime
#  body                 :text
#  is_accepted          :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  removed              :boolean
#  comment_count        :integer
#

class Answer < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern
  include OwnerValidationConcern
  include SiteIdScopedConcern
  include ValidUtfBodyConcern

  belongs_to :question
  belongs_to :owner, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  has_many :answer_tags, dependent: :destroy
  has_many :tags, through: :answer_tags

  before_save :update_question

  scope :existing, -> { where('answers.removed IS NULL') }

  protected

  def translate_html_entities
    self.body = $html_entities.decode(self.body)
  end

  private

  def update_question
    if self.is_accepted
      self.question.update(accepted_answer_id: self.id)
    end
  end

end
