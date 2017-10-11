class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :external_id

      t.string :email, uniq: true
      t.string :frequency
      t.string :token

      t.timestamps
    end
  end
end
