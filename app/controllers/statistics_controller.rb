class StatisticsController < ApplicationController
  def index
   @test = Test.find(1)
   if @test.tries.any?
     time = 0
     @test.tries.where(:status => 'Выполнен').each do |try|
       time = time + try.timer.min*60 + try.timer.hour*3600
     end
     @timer = time/@test.tries.count
     @hours = (@timer/3600).to_i
     @minutes = (@timer/60).to_i - @hours*60
   end
  end
end