class Task < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :associations, dependent: :destroy
  has_many :task_contents, dependent: :destroy
  belongs_to :test
  accepts_nested_attributes_for :answers,  :reject_if => proc { |a| a['text'].blank? } , :allow_destroy => true
  accepts_nested_attributes_for :associations,  :reject_if => proc { |a| a['text'].blank? } , :allow_destroy => true
  accepts_nested_attributes_for :task_contents,:reject_if => proc { |a| a['file_content'].blank? }, :allow_destroy => true
  belongs_to :section
  belongs_to :eqvgroup
  validates :test_id, presence: true
  validates :eqvgroup_id, presence: true
end
