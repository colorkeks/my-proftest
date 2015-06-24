class InitVersions < ActiveRecord::Migration
  def change
=begin
    Task.find_each do |task|
      task.touch_with_version
    end
    Answer.find_each do |answer|
      answer.touch_with_version
    end
    Association.find_each do |association|
      association.touch_with_version
    end
=end
  end
end
