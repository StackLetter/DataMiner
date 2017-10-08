class CreateAccountUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :account_users do |t|
      t.references :account, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
