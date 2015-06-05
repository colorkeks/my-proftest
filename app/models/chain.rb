class Chain < ActiveRecord::Base
  belongs_to :test
  belongs_to :section
  belongs_to :eqvgroup
  validates :test, presence: true
  validates :eqvgroup, presence: true
  #validate :eqvgroup_and_section_valid
  has_many :tasks, -> { order(chain_position: :asc) }

  after_destroy :move_tasks_to_trash

  def eqvgroup_and_section_valid
    if !(self.section == self.eqvgroup.section)
      errors.add(:eqvgroup, "Невозможно назначить данную группу")
    end
  end

  def task_type
    'Цепочка'
  end

  def text
    "Цепочка ##{self.id} [#{self.tasks.count}]"
  end

  def title
    text
  end

  def move_tasks_to_trash
    self.tasks.map(&:move_to_trash!)
  end

  def change_eqvgroup!(eqvgroup)
    self.eqvgroup = eqvgroup
    self.save!
    self.tasks.each do |task|
      task.eqvgroup = eqvgroup
      task.save!
    end
  end

  def change_section_and_eqvgroup!(section, eqvgroup=nil)
    if eqvgroup.nil?
      eqvgroup = section.eqvgroups.order(:number).last
    end
    self.section = section
    self.eqvgroup = eqvgroup
    self.save!
    self.tasks.each do |task|
      task.section = section
      task.eqvgroup = eqvgroup
      task.save!
    end
  end
end
