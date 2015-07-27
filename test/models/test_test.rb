require 'test_helper'

class TestTest < ActiveSupport::TestCase
  test "get_tasks_for_current_algorithm" do
    test = tests(:one)
    chain = chains(:one)
    task1 = tasks(:one)
    task2 = tasks(:two)
    task3 = test.tasks.build(eqvgroup: eqvgroups(:one))
    task3.save!

    chain.add_task!(task1)
    chain.add_task!(task2)
    chain.add_task!(task3)

    tasks = test.get_tasks_for_current_algorithm

    assert_equal tasks[0], task1
    assert_equal tasks[1], task2
    assert_equal tasks[2], task3
  end
end
