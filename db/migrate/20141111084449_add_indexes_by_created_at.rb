class AddIndexesByCreatedAt < ActiveRecord::Migration
  def change
    add_index :orders, :created_at
    add_index :users, :created_at
  end
end
