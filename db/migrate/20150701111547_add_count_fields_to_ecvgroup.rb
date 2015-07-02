class AddCountFieldsToEcvgroup < ActiveRecord::Migration
  def change
    add_column :eqvgroups, :task_count,  :integer, default: 0
    add_column :eqvgroups, :chain_count, :integer, default: 0
  end
end
