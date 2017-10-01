class Badge < ApplicationRecord
  include StackApiModelConcern

  has_many :user_badges, dependent: :destroy
end
