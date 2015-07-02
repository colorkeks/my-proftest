require 'test_helper'

class TryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "prepare" do
    test = tests(:one)
    try = Try.new(test: test)
    try.prepare
    assert try.task_results_queue.sort, [1,2]
  end
end