class AddTokenFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :token_expire_at, :datetime

    add_index :users, :token, unique: true

  end
end
