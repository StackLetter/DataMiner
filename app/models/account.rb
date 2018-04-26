# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  external_id     :integer
#  email           :string
#  frequency       :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  available_token :boolean
#

class Account < ApplicationRecord

  validates :email, uniqueness: true

  scope :available_token_accounts, -> { where(available_token: true) }

  has_many :users

end
