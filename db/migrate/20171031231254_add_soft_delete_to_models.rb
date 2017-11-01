class AddSoftDeleteToModels < ActiveRecord::Migration[5.1]
  def change

    add_column :questions, :removed, :boolean
    add_column :answers, :removed, :boolean
    add_column :users, :removed, :boolean
    add_column :comments, :removed, :boolean

  end
end
