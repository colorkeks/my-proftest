class AddDeletedAtToTestAndTestGroups < ActiveRecord::Migration
  def change
    add_column :tests, :deleted_at, :datetime
    add_column :test_groups, :deleted_at, :datetime
    #add_index :tests, :deleted_at
    #add_index :test_groups, :deleted_at

    tg = TestGroup.find_or_initialize_by(name: 'Корзина')
    tg.save!
  end
end
