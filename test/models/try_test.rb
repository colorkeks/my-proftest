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


end