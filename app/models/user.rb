class User < ApplicationRecord
  include StackApiModelConcern

  has_many :user_tags, dependent: :destroy
  has_many :user_sites, dependent: :destroy
  has_many :user_badges, dependent: :destroy
end
