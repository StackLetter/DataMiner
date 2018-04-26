# == Schema Information
#
# Table name: answer_tags
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AnswerTag < ApplicationRecord

  belongs_to :answer
  belongs_to :tag
end
