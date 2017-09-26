class CreateUsers < ActiveRecord::Migration[5.1]
  def change

    # nie je potrebne davat ID ako primary key alebo tak, to robi automaticky
    create_table :users do |t|
      t.integer :external_id, index: true
      t.integer :age
      t.integer :badges_count
      t.integer :reputation
      t.integer :accept_rate
      # t.integer :reputation_change_day
      # t.integer :reputation_change_month
      # t.integer :reputation_change_year
      # t.integer :reputation_change_week

      t.date :creation_date
      t.date :last_access_date

      t.string :display_name
      t.string :user_type
      t.string :website_url
      t.string :location
      t.string :email
      t.string :token

      t.boolean :is_employee

      t.timestamps
    end

    add_index :users, :id
  end
end
