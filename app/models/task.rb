class Task < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :task_contents, dependent: :destroy
  belongs_to :test
  accepts_nested_attributes_for :answers,  :reject_if => proc { |a| a['text'].blank? } , :allow_destroy => true
  accepts_nested_attributes_for :task_contents, :allow_destroy => true
end
