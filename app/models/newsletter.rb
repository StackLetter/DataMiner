class Newsletter < ApplicationRecord

  has_many :newsletter_sections
  has_many :evaluation_newsletters

end
