class InitVersions < ActiveRecord::Migration
  def change
    Task.find_each do |task|
      task.touch_with_version
    end
    Answer.find_each do |answer|
      answer.touch_with_version
    end
    Association.find_each do |association|
      association.touch_with_version
    end
    TaskContent.find_each do |tk|
      tk.touch_with_version
    end
    Test.find_each do |t|
      t.touch_with_version
    end
  end
end