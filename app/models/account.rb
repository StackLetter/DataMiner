class Account < ApplicationRecord

  has_many :users, through: :account_users

end
