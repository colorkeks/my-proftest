require 'test_helper'

class TryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "prepare" do
    test = tests(:one)
    test.tasks.map(&:touch_with_version) #Создаем версии
    try = Try.new(test: test)
    result = try.prepare

    assert_equal true, result
    task_results = try.task_results.order(:id)
    assert_equal try.task_results_queue.sort, task_results.map{|tr| tr.id}
  end

  test "can show task result" do
    test = tests(:one)
    try = Try.new(test: test)
    test.tasks.map(&:touch_with_version) #Создаем версии
    result = try.prepare

    assert_equal true, result
    assert_equal try.can_show_task_result?(try.task_results.first), true
    assert_equal try.can_show_task_result?(try.task_results.last), true

    #Проверка с завершенным вопросом
    tr = try.task_results.last
    tr.update(status: 'правильно')
    assert_equal try.can_show_task_result?(tr), false

    #Проверка цепочек

    chain = chains(:one)
    task1 = tasks(:one)
    task2 = tasks(:two)
    chain.add_task!(task1)
    chain.add_task!(task2)
    try = Try.new(test: test)
    try.prepare

    tr1 = TaskResult.find(try.task_results_queue[0])
    tr2 = TaskResult.find(try.task_results_queue[1])

    assert_equal try.can_show_task_result?(tr1), true
    assert_equal try.can_show_task_result?(tr2), false

    tr1.update(status: 'правильно')
    assert_equal try.can_show_task_result?(tr2), true

  end

  def prepare_task
    attrs = tests(:one).attributes.except('id', 'lft', 'parent_id', 'rgt', 'depth')
    test = Test.new(attrs)
    assert_equal test.save, true
    task = test.tasks.build(eqvgroup: test.eqvgroups.first)
    task.point = 1
    return task
  end

  def prepare_single_task_result
    task = prepare_task
    test = task.test
    task.task_type = 'Единичный выбор'
    task.answers.build(correct: true).save
    task.answers.build(correct: false).save
    task.answers.build(correct: false).save
    assert_equal task.save, true
    try = Try.new(test: test)
    result = try.prepare
    task_result = try.task_results.first
    return task_result
  end

  def prepare_multiple_task_result
    task = prepare_task
    test = task.test
    task.task_type = 'Множественный выбор'
    task.answers.build(correct: true).save
    task.answers.build(correct: true).save
    task.answers.build(correct: false).save
    task.answers.build(correct: false).save
    assert_equal task.save, true
    try = Try.new(test: test)
    result = try.prepare
    task_result = try.task_results.first
    return task_result
  end

  def prepare_association_task_result
    task = prepare_task
    test = task.test
    task.task_type = 'Сопоставление'
    task.answers.build(serial_number: 1).save
    task.answers.build(serial_number: 2).save
    task.answers.build(serial_number: 3).save
    task.associations.build(serial_number: 1).save
    task.associations.build(serial_number: 2).save
    assert_equal task.save, true
    try = Try.new(test: test)
    result = try.prepare
    task_result = try.task_results.first
    return task_result
  end

  def prepare_serial_task_result
    task = prepare_task
    test = task.test
    task.task_type = 'Последовательность'
    task.answers.build(serial_number: 1).save
    task.answers.build(serial_number: 2).save
    task.answers.build(serial_number: 3).save
    task.answers.build(serial_number: 4).save
    assert_equal task.save, true
    try = Try.new(test: test)
    result = try.prepare
    task_result = try.task_results.first
    return task_result
  end

  def prepare_open_task_result
    task = prepare_task
    test = task.test
    task.task_type = 'Открытый вопрос'
    task.answers.build(text: 'text').save
    assert_equal task.save, true
    try = Try.new(test: test)
    result = try.prepare
    task_result = try.task_results.first
    return task_result
  end

  test 'check answer single correct' do
    task_result = prepare_single_task_result
    correct_answer = task_result.user_answers.find{|ua| ua.answer_was.correct}
    params = HashWithIndifferentAccess.new('user_answers' => [correct_answer.id.to_s])
    task_result.check_user_answer!(params)

    assert_equal task_result.save, true
    assert_equal task_result.point, 1
    assert_equal task_result.status, 'правильно'

    ua = correct_answer
    assert_equal ua.user_reply, 't'
    assert_equal ua.correct, true
  end

  test 'check answer single incorrect' do
    task_result = prepare_single_task_result
    incorrect_answer = task_result.user_answers.find{|ua| !ua.answer_was.correct}
    params = HashWithIndifferentAccess.new('user_answers' => [incorrect_answer.id.to_s])
    task_result.check_user_answer!(params)

    assert_equal task_result.save, true
    assert_equal task_result.point, 0
    assert_equal task_result.status, 'не правильно'
  end

  test 'check answer multiple correct' do
    task_result = prepare_multiple_task_result
    correct_answers = task_result.user_answers.find_all{|ua| ua.answer_was.correct}
    params = HashWithIndifferentAccess.new('user_answers' => [correct_answers[0].id.to_s, correct_answers[1].id.to_s])
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 1, task_result.point
    assert_equal 'правильно', task_result.status
  end

  test 'check answer multiple partial correct' do
    task_result = prepare_multiple_task_result
    correct_answers = task_result.user_answers.find_all{|ua| ua.answer_was.correct}
    params = HashWithIndifferentAccess.new('user_answers' => [correct_answers[0].id.to_s])
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 0.5, task_result.point
    assert_equal 'частично правильно', task_result.status

    ua = correct_answers.first
    assert_equal ua.user_reply, 't'
    assert_equal ua.correct, true
  end

  test 'check answer multiple correct plus incorrect' do
    task_result = prepare_multiple_task_result
    correct_answers = task_result.user_answers.find_all{|ua| ua.answer_was.correct}
    incorrect_answers = task_result.user_answers.find_all{|ua| !ua.answer_was.correct}
    params = HashWithIndifferentAccess.new('user_answers' => [correct_answers.first.id.to_s, incorrect_answers.first.id.to_s])
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 0, task_result.point
    assert_equal 'не правильно', task_result.status
  end

  test 'check associations correct' do
    task_result = prepare_association_task_result
    params = HashWithIndifferentAccess.new('associations' => {}.
      merge({task_result.user_answers[0].id.to_s => [task_result.user_answers[0].correct_user_association ? task_result.user_answers[0].correct_user_association.id.to_s : 'Не выбрано']}).
      merge({task_result.user_answers[1].id.to_s => [task_result.user_answers[1].correct_user_association ? task_result.user_answers[1].correct_user_association.id.to_s : 'Не выбрано']}).
      merge({task_result.user_answers[2].id.to_s => [task_result.user_answers[2].correct_user_association ? task_result.user_answers[2].correct_user_association.id.to_s : 'Не выбрано']})
    )
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 1, task_result.point
    assert_equal 'правильно', task_result.status

    task_result.user_answers.each_with_index do |ua, index|
      #assert_equal index+1, ua.serial_number
      assert_equal true, ua.correct
    end
  end

  test 'check associations partial correct' do
    task_result = prepare_association_task_result
    params = HashWithIndifferentAccess.new('associations' => {}.
      merge({task_result.user_answers[0].id.to_s => [task_result.user_answers[0].correct_user_association ? task_result.user_answers[0].correct_user_association.id.to_s : 'Не выбрано']}). #Правильный
      merge({task_result.user_answers[2].id.to_s => [task_result.user_answers[1].correct_user_association ? task_result.user_answers[1].correct_user_association.id.to_s : 'Не выбрано']}). #Неправильный
      merge({task_result.user_answers[1].id.to_s => [task_result.user_answers[2].correct_user_association ? task_result.user_answers[2].correct_user_association.id.to_s : 'Не выбрано']})  #Неправильный
    )
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 1.0/3, task_result.point
    assert_equal 'частично правильно', task_result.status
  end

  test 'check serial correct' do
    task_result = prepare_serial_task_result
    correct_answers_ordered = task_result.user_answers.sort{|a1, a2| a2.answer_was.serial_number <=> a1.answer_was.serial_number}
    params = HashWithIndifferentAccess.new('user_answers' => {}.
      merge({correct_answers_ordered[0].id.to_s => '1'}).
      merge({correct_answers_ordered[1].id.to_s => '2'}).
      merge({correct_answers_ordered[2].id.to_s => '3'}).
      merge({correct_answers_ordered[3].id.to_s => '4'})
    )
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 0, task_result.point
    assert_equal 'не правильно', task_result.status
  end

  test 'check serial incorrect' do
    task_result = prepare_serial_task_result
    correct_answers_ordered = task_result.user_answers.sort{|a1, a2| a2.answer_was.serial_number <=> a1.answer_was.serial_number}
    params = HashWithIndifferentAccess.new('user_answers' => {}.
      merge({correct_answers_ordered[0].id.to_s => '1'}).
      merge({correct_answers_ordered[1].id.to_s => '2'}).
      merge({correct_answers_ordered[2].id.to_s => '4'}). #Неправильно
      merge({correct_answers_ordered[3].id.to_s => '3'})  #Неправильно
    )
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 0, task_result.point
    assert_equal 'не правильно', task_result.status
  end

  test 'check open correct' do
    task_result = prepare_open_task_result
    params = HashWithIndifferentAccess.new('user_answer' => 'text')
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 1, task_result.point
    assert_equal 'правильно', task_result.status

    correct_answer = task_result.user_answers.find{|ua| ua.answer_was.text = 'text'}
    ua = correct_answer
    assert_equal ua.user_reply, 'text'
    assert_equal ua.correct, true
  end

  test 'check open incorrect' do
    task_result = prepare_open_task_result
    params = HashWithIndifferentAccess.new('user_answer' => 'incorrect_text')
    task_result.check_user_answer!(params)

    assert_equal true, task_result.save
    assert_equal 0, task_result.point
    assert_equal 'не правильно', task_result.status

    correct_answer = task_result.user_answers.find{|ua| ua.answer_was.text = 'text'}
    ua = correct_answer
    assert_equal 'incorrect_text', ua.user_reply
    assert_not_equal true, ua.correct
  end

  test 'process chain for task result' do
    test = tests(:one)
    task1 = tasks(:one)
    task2 = tasks(:two)
    chain = chains(:one)
    chain.add_task!(task1)
    chain.add_task!(task2)

    try = Try.new(test: test)
    result = try.prepare

    task_result = try.task_results.first
    task_result.status = 'не правильно'
    task_results = try.process_chain_for_task_result!(task_result)
    assert_equal 'не правильно', task_results.last.status

  end

end