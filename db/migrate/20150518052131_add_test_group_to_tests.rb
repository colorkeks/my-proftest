class AddTestGroupToTests < ActiveRecord::Migration
  def change
    add_column :tests, :test_group_id, :integer
    add_index :tests, :test_group_id

    group = TestGroup.find_or_initialize_by(name: 'Тесты')
    group.save!
    Test.all.each do |test|
      test.test_group = group
      test.save!
    end
  end
end
