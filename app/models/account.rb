class Account < ApplicationRecord

  validates :email, uniqueness: true

end
