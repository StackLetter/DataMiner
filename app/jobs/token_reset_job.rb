class TokenResetJob < ApplicationJob

  def perform
    Account.update_all(available_token: true)
  end

end