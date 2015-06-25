require 'test_helper'

class ChainTest < ActiveSupport::TestCase
  test "add task" do
    task1 = tasks(:one)
    task2 = tasks(:two)
    chain = chains(:one)
    chain.add_task!(task1)
    chain.add_task!(task2)

    assert_equal task1.chain, chain
    assert_equal task1.chain_position, 1
    assert_equal task2.chain, chain
    assert_equal task2.chain_position, 2
  end
end
