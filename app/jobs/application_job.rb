class ApplicationJob < ActiveJob::Base
  include TokenHelper

  def klass_error_msg
    '[Job Error]'
  end

end
