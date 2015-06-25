require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  fixtures
  test "the truth" do
    assert true
  end

  test "new task empty chain_position" do
    test = tests(:one)
    task = test.tasks.build(eqvgroup: eqvgroups(:one))
    task.save!
    assert_equal task.chain_position, nil
  end
end