class Badge < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern

  has_many :user_badges, dependent: :destroy
end
