class AddNestedToTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :parent_id, :integer

    add_column :tests, :lft,       :integer
    add_column :tests, :rgt,       :integer

    # optional fields
    add_column :tests, :depth,          :integer
    add_column :tests, :children_count, :integer

    # This is necessary to update :lft and :rgt columns
  end

  def self.down
    remove_column :tests, :parent_id
    remove_column :tests, :lft
    remove_column :tests, :rgt

    # optional fields
    remove_column :tests, :depth
    remove_column :tests, :children_count
  end

end
