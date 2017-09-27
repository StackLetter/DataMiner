class ApplicationJob < ActiveJob::Base

  def klass_error_msg
    '[Job Error]'
  end

end
