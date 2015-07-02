class Test < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  has_many :tries
  has_many :tasks, dependent: :destroy
  has_many :assigned_tests
  acts_as_nested_set
  belongs_to :test_group
  has_many :sections, dependent: :destroy
  has_many :eqvgroups, dependent: :destroy
  has_many :chains, dependent: :destroy
  after_create :add_eqvgroup
  include SoftDeletion
  has_paper_trail

  def self.search_test(q)
    if q.empty?
      Test.all
    else
      Test.where("description LIKE ? OR title LIKE ?", "#{q}%", "%#{q}%")
    end
  end

  def add_eqvgroup
    eg = self.eqvgroups.build(number: 1)
    eg.save!
  end

  def get_tasks_all_random
    task_queue = []
    self.tasks.existing.order('RANDOM()').each do |task|
      if task.chain.present?
        if task.chain_position == 1
          task_queue += self.tasks.existing.where(chain: task.chain).order(:chain_position).all
        else
          next
        end
      else
        task_queue += [task]
      end
    end
    task_queue
  end

  def get_tasks_for_current_algorithm
    task_queue = []
    if self.algorithm == 'Все задания' || self.algorithm.blank?
      task_queue = self.get_tasks_all_random
    elsif self.algorithm == 'Ограниченое количество заданий'
      task_required_count = ((self.tasks.existing.count.to_f / 100.0) * self.percent_tasks).round
      task_queue = self.get_tasks_all_random.take(task_required_count)
    else
      raise 'Неизвестный алгоритм выбора заданий'
    end
    task_queue
  end

end
