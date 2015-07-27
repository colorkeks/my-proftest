class AddRequestUuidToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :request_uuid, :string
    add_column :versions, :controller_name, :string
    add_column :versions, :action_name, :string
  end
end
