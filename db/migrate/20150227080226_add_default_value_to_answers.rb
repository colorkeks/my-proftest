class AddDefaultValueToAnswers < ActiveRecord::Migration
  def up
    change_column :answers, :correct, :boolean, :default => false
  end

  def down
    change_column :answers, :correct, :boolean, :default => nil
  end
end
