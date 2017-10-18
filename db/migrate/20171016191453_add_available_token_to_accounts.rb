class AddAvailableTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :available_token, :boolean
  end
end
