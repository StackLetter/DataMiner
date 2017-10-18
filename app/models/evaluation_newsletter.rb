class EvaluationNewsletter < ApplicationRecord

  USER_RESPONSE = ['open', 'like', 'stars', 'click']
  USER_RESPONE_DETAIL = ['1', '2', '3', '4', '5']
  CONTENT_TYPE = ['question', 'answer', 'badge', 'user_badge', 'comment', 'section', 'structure', 'newsletter']

  validates :content_type, inclusion: CONTENT_TYPE
  validates :user_response_type, inclusion: USER_RESPONSE
  validates :user_response_detail, inclusion: USER_RESPONE_DETAIL, allow_nil: true

end
