class AddInitialModes < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.test_modes.empty?
        user.test_modes.build(name: 'Нейтральный', date_beg: Date.today)
        user.save!
      end
    end
  end
end
