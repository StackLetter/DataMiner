# == Schema Information
#
# Table name: questions
#
#  id                          :integer          not null, primary key
#  accepted_answer_id          :integer
#  bounty_amount               :integer
#  external_id                 :integer
#  site_id                     :integer
#  owner_id                    :integer
#  score                       :integer
#  up_vote_count               :integer
#  down_vote_count             :integer
#  view_count                  :integer
#  bounty_closes_date          :datetime
#  closed_date                 :datetime
#  creation_date               :datetime
#  community_owned_date        :datetime
#  last_activity_date          :datetime
#  locked_date                 :datetime
#  body                        :text
#  title                       :string
#  is_answered                 :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  removed                     :boolean
#  accepted_answer_external_id :integer
#  comment_count               :integer
#

class Question < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern
  include OwnerValidationConcern
  include SiteIdScopedConcern
  include ValidUtfBodyConcern

  belongs_to :owner, class_name: 'User', optional: true
  has_many :answers, dependent: :destroy
  has_one :accepted_answer, class_name: 'Answer', dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  has_many :comments, dependent: :destroy

  scope :existing, -> { where('questions.removed IS NULL') }

  after_commit :accepted_answer_exists?

  protected

  def translate_html_entities
    self.body = $html_entities.decode(self.body)
    self.title = $html_entities.decode(self.title)
  end

  private

  def accepted_answer_exists?
    GenericParserJob.perform_later('Answer', [self.accepted_answer_external_id], self.site_id) if self.accepted_answer_external_id &&
        !Answer.exists?(external_id: self.accepted_answer_external_id)
  end
end
