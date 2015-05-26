class AddEqvgroupToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :eqvgroup_id, :integer

    #Добавляем группы в тесты и разделы
    tests = Test.all
    tests.each do |test|
      if test.eqvgroups.empty?
        eg  = test.eqvgroups.build
        eg.save!
      end
      number = 1
      test.sections.each do |section|
        number += 1
        eg  = test.eqvgroups.build(section: section, number:number)
        eg.save!
      end
    end

    #Добавляем группы в задачи
    Task.reset_column_information
    tasks = Task.all
    tasks.each do |task|
      if task.section.nil?
        task.eqvgroup = task.test.eqvgroups.order('number').first
      else
        task.eqvgroup = task.section.eqvgroups.order('number').first
      end
      task.save!
    end

    change_column :tasks, :eqvgroup_id, :integer, null: false
    add_index :tasks, :eqvgroup_id

  end
end
