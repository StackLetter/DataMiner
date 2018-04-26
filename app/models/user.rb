# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  external_id             :integer
#  account_id              :integer
#  site_id                 :integer
#  age                     :integer
#  reputation              :integer
#  accept_rate             :integer
#  reputation_change_month :integer
#  reputation_change_year  :integer
#  reputation_change_week  :integer
#  creation_date           :datetime
#  last_access_date        :datetime
#  display_name            :string
#  user_type               :string
#  website_url             :string
#  location                :string
#  is_employee             :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  removed                 :boolean
#  answers_count           :integer
#  questions_count         :integer
#  user_badges_count       :integer
#  comments_count          :integer
#  segment_id              :integer
#  segment_changed         :boolean
#

class User < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern
  include SiteIdScopedConcern

  has_many :user_tags, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :sites, through: :user_sites
  has_many :tags, through: :user_tags
  has_many :badges, through: :user_badges
  has_many :questions, dependent: :destroy, foreign_key: :owner_id
  has_many :answers, dependent: :destroy, foreign_key: :owner_id
  has_many :comments, dependent: :destroy, foreign_key: :owner_id
  has_many :user_favorites
  has_many :newsletters
  has_many :evaluation_newsletters, through: :newsletters
  belongs_to :msa_segment, foreign_key: :segment_id, optional: true
  has_many :msa_user_segment_changes

  scope :existing, -> { where('users.removed IS NULL') }
  scope :stackletter_users, -> { where('users.account_id IS NOT NULL') }

  def self.find_model_object(api_item_response, site_id = 1)
    return self.find_by(external_id: api_item_response['external_id'], site_id: site_id) if api_item_response['external_id']
    return self.find_by(external_id: api_item_response['user_id'], site_id: site_id) if api_item_response['user_id']
    nil
  end

  def without_activity?
    self.answers.count == 0 && self.questions.count == 0 && self.comments.size == 0
  end

  def new_badges?(from_date)
    user_badges.where('created_at >= ?', from_date).any?
  end

  protected

  def translate_html_entities
    self.display_name = $html_entities.decode(self.display_name)
  end
end
