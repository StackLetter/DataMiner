class Newsletter < ApplicationRecord

  belongs_to :user
  has_many :newsletter_sections
  has_many :evaluation_newsletters

end
