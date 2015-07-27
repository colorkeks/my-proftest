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

  ALGORITHMS = [
      'Все задания',
      'Ограниченое количество заданий',
      'Настройка эквивалентных групп'
  ]
  #validates :algorithm, inclusion: ALGORITHMS

  scope :attestation, -> {where(attestation: true)}
  scope :training, -> {where(training: true)}

  def self.search_test(q,mode)
    if mode == 'Аттестация'
      if q.empty?
        Test.attestation.existing.all
      else
        Test.attestation.existing.where("description LIKE ? OR title LIKE ?", "#{q}%", "%#{q}%")
      end
    elsif mode == 'Тренировка'
      if q.empty?
        Test.training.existing.all
      else
        Test.training.existing.where("description LIKE ? OR title LIKE ? AND attestation = false", "#{q}%", "%#{q}%")
      end
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
    elsif self.algorithm == 'Настройка эквивалентных групп'
      self.eqvgroups.order(:number).each do |eg|
        #
        task_queue += eg.tasks.existing.where(chain_id: nil).order('RANDOM()').take(eg.task_count)
        chained_first_tasks = eg.tasks.existing.where(chain_position: 1).order('RANDOM()').take(eg.chain_count)
        chained_first_tasks.each do |cft|
          task_queue += eg.tasks.existing.where(chain: cft.chain).order(:chain_position).all
        end
      end
    else
      raise 'Неизвестный алгоритм выбора заданий'
    end
    task_queue
  end

  def average_tries_time
    tries = self.tries.where(:status => 'Выполнен')
    if tries.count > 0
      total_time = tries.all.inject(0){|sum, t| sum + (t.updated_at-t.created_at).to_i}  #seconds
      average_time = total_time / tries.count
    else
      0
    end
  end

  def average_tries_rate
    tries = self.tries.where(:status => 'Выполнен')
    if tries.count > 0
      total_rate = tries.all.inject(0){|sum, t| sum + (t.rate||0)}
      average_rate = total_rate.to_f / tries.count
    else
      0
    end
  end

  def average_tries_point
    tries = self.tries.where(:status => 'Выполнен')
    if tries.count > 0
      total_points = tries.all.inject(0){|sum, t| sum + (t.task_results.sum(:point))}
      average_point = total_points.to_f / tries.count
    else
      0
    end
  end


end
