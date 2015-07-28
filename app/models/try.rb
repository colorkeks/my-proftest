class Try < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  belongs_to :test_mode
  belongs_to :assigned_test
  serialize :task_results_queue, Array
  has_many :task_results, dependent: :destroy
  accepts_nested_attributes_for :task_results

  def populate_tasks
    tasks = self.test.get_tasks_for_current_algorithm
    tasks.each do |task|
      task_result = self.task_results.build(
          task_version: task.versions.last,
          #:point => task.point,
          #:text => task.text,
          #:hint => task.hint,
          #:task_type => task.task_type,
          :status => 'ответ не дан',
          :task_id => task.id
      )
      task.answers.order(task.test.mix_answers ? 'RANDOM()' : 'id ASC').each do |answer|
        task_result.user_answers.build(
            answer_version: answer.versions.last,
            #:user_reply => false,
            #:correct => answer.correct,
            #:text => answer.text,
            #:serial_number => answer.serial_number,
            #:point => answer.point,
            #:task_id => task.id,
            #:answer_id => answer.id,
            #:user_association_id => nil
        )
      end
      task.associations.order(self.test.mix_answers ? 'RANDOM()' : 'id ASC').each do |association|
        task_result.user_associations.build(
            association_version: association.versions.last,
            #:text => association.text,
            #:serial_number => association.serial_number,
            #:task_id => task.id,
            #:association_id => association.id,
            #:user_answer_id => nil
        )
      end
      task.task_contents.each do |task_content|
        task_result.try_task_contents.build(
          task_content_version: task_content.versions.last
        )
      end
    end
    self
  end

  def set_task_results_queue
    self.task_results_queue = self.task_results.map{|tr| tr.id}
  end

  def prepare
    self.populate_tasks
    result = self.save
    self.set_task_results_queue
    result = result && self.save
  end

  #Определяет, можно ли отвечать на этот вопрос
  def can_show_task_result?(task_result)
    if task_result.status == 'ответ не дан'
      task_was = task_result.task_version.item_version
      if task_was.chain_id
        if task_was.chain_position == 1
          return true
        else
          #Определяем индекс в очереди
          index = self.task_results_queue.index(task_result.id)
          prev_id = self.task_results_queue[index-1]
          prev_task_result = self.task_results.find(prev_id)
          return !(prev_task_result.status == 'ответ не дан')
        end
      else
        return true
      end
    else
      return false
    end
  end

  def get_question(current_task_index=nil)
    #Проверка на время

    task_result = nil
    #Ищем задачу по индексу
    if current_task_index && (current_task_index < self.task_results_queue.count)
      task_result_id = self.task_results_queue[current_task_index]
      task_result = self.task_results.find(task_result_id)
    end

    #Ищем задачу по порядку, если нет индекса или нельзя отобразить задачу по индексу
    if current_task_index.blank? || task_result.nil? || !self.can_show_task_result?(task_result)
      task_result = nil
      self.task_results_queue.each do |tr_id|
        tr = self.task_results.find(tr_id)
        if self.can_show_task_result?(tr)
          task_result = tr
          break
        end
      end
    end
    return task_result
  end

  def task_results_for_chain_id(chain_id)
    self.task_results.all.select{|tr| tr.task_version.item_version.chain_id == chain_id}
  end

  def process_chain_for_task_result!(task_result)
    trs = []
    if task_result.status == 'не правильно' && task_result.task_was.chain_id
      self.task_results_for_chain_id(task_result.task_was.chain_id).each do |tr|
        if tr.status == 'ответ не дан'
          tr.status = 'не правильно'
          tr.point = 0
          trs += [tr]
        end
      end
    end
    return trs
  end

  def self.finish_by_timer
    tries = Try.where('status = ? AND created_at < ? ', 'Не выполнен', Time.now - CLOSE_TRIES_TIME.hours ).to_a
    p "[#{Time.now}] finish #{tries.length} tries"
    tries.each do |try|
      try.task_results.where(:status => 'ответ не дан').each do |task_result|
        begin
          task_result.point = 0
          task_result.save!
        rescue ActiveRecord::RecordInvalid
          p "invalid task_result: #{task_result}"
        end
      end
      try.status = 'Выполнен'
      try.save!
    end
  end

end
