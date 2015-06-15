class Chain < ActiveRecord::Base
  belongs_to :test
  belongs_to :section
  belongs_to :eqvgroup
  validates :test, presence: true
  validates :eqvgroup, presence: true
  validate :eqvgroup_and_section_valid
  has_many :tasks, -> { order(chain_position: :asc) }, dependent: :nullify

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
    if tasks.count == 0
      add_text = "В цепочке нет заданий"
    else
      add_text = "Задание: #{tasks.first.text}"
    end
    result = "[#{self.tasks.count}] #{add_text}"
  end

  def title
    "Цепочка ##{self.id} [#{self.tasks.count}]"
  end

  def move_tasks_to_trash
    self.tasks.map(&:move_to_trash!)
  end

  def change_eqvgroup!(eqvgroup_param)
    self.eqvgroup = eqvgroup_param
    self.save!
    self.tasks.each do |task|
      task.eqvgroup = eqvgroup_param
      task.save!
    end
  end

  def change_section_and_eqvgroup!(section_param, eqvgroup_param=nil)
    return true if self.section == section_param
    if eqvgroup_param.nil?
      if section_param
        eqvgroup_param = section_param.eqvgroups.order(:number).last
      else
        eqvgroup_param = self.test.eqvgroups.where(section: nil).order(:number).last
      end
    end
    self.section = section_param
    self.eqvgroup = eqvgroup_param
    self.save!
    self.tasks.each do |task|
      task.section = section_param
      task.eqvgroup = eqvgroup_param
      task.save!
    end
  end

  def split!
    self.tasks.each do |task|
      task.reload
      task.remove_from_list
    end
    self.destroy!
  end

  def add_task!(task)
    if task.chain && (task.chain != self)
      task.remove_from_list
    end
    task.chain = self
    task.section = self.section
    task.eqvgroup = self.eqvgroup
    task.save!
  end

  def self.full_chains_from_task_ids(task_ids_param)
    if task_ids_param.is_a?(String)
      task_ids_param = task_ids_param.split(',').map(&:to_i)
    end
    chains = self.includes(:tasks).where(tasks: {id: task_ids_param}).references(:tasks)
    chains = self.where(id: chains.map(&:id)) #Перезагружаем цепочки
    chains.select{|chain| (chain.task_ids - task_ids_param).empty? }
  end
end
