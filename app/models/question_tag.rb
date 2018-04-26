# == Schema Information
#
# Table name: question_tags
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  tag_id      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class QuestionTag < ApplicationRecord

  belongs_to :question
  belongs_to :tag
end
