class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def klass_error_msg
    '[Controller Error]'
  end
end
