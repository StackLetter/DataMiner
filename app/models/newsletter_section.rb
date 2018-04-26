# == Schema Information
#
# Table name: newsletter_sections
#
#  id            :integer          not null, primary key
#  newsletter_id :integer          not null
#  name          :string
#  content_type  :string
#  description   :text
#  content_ids   :integer          is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  section_id    :integer
#

class NewsletterSection < ApplicationRecord
end
