class FixTests < ActiveRecord::Migration
  def change
    Test.all.each do |test|
      if test.timer.blank?
        test.timer = 60
        test.save!
      end
    end
  end
end
