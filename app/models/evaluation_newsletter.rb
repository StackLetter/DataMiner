class EvaluationNewsletter < ApplicationRecord

  belongs_to :newsletter

  USER_RESPONSE = ['open', 'feedback', 'click', 'unsubscribe']
  USER_RESPONE_DETAIL = ['-1', '0', '1']
  CONTENT_TYPE = ['question', 'answer', 'badge', 'user_badge', 'comment', 'section', 'newsletter', 'tag', 'user_tag']

  validates :content_type, inclusion: CONTENT_TYPE
  validates :user_response_type, inclusion: USER_RESPONSE
  validates :user_response_detail, inclusion: USER_RESPONE_DETAIL, allow_nil: true

end
