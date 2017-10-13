class CreateUsers < ActiveRecord::Migration[5.1]
  def change

    create_table :users do |t|
      t.integer :external_id, index: true
      t.integer :account_id
      t.integer :site_id
      t.integer :age
      t.integer :reputation
      t.integer :accept_rate
      t.integer :reputation_change_month
      t.integer :reputation_change_year
      t.integer :reputation_change_week

      t.datetime :creation_date
      t.datetime :last_access_date

      t.string :display_name
      t.string :user_type
      t.string :website_url
      t.string :location

      t.boolean :is_employee

      t.timestamps
    end

    add_index :users, :id
  end
end
