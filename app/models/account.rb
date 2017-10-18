class Account < ApplicationRecord

  validates :email, uniqueness: true

  scope :available_token_accounts, -> { where(available_token: true) }

end
