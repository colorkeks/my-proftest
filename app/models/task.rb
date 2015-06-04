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
  validates :eqvgroup_id, presence: true, if: 'existing?'
  validate :eqvgroup_and_section_valid, if: 'existing?'
  validate :chain_eqvgroup_and_section_valid, if: 'existing? && chain'
  include SoftDeletion

  belongs_to :chain
  acts_as_list scope: :chain, column: :chain_position

  def eqvgroup_and_section_valid
    if !(self.section == self.eqvgroup.section)
      errors.add(:eqvgroup, "Невозможно назначить данную группу")
    end
  end

  def chain_eqvgroup_and_section_valid
    if self.chain && !(self.section == self.chain.section && self.eqvgroup == self.chain.eqvgroup)
      errors.add(:chain, "Невозможно переместить в цепочку")
    end
  end

  def remove_from_list
    if in_list?
      old_position = send(position_column).to_i
      update_column position_column, nil # Удаляем id
      send("#{position_column}=", old_position)
      decrement_positions_on_lower_items
      set_list_position(nil)
      update_column scope_name, nil # Удаляем из scope
    end
  end

  def move_to_trash!
    task = self
    task.eqvgroup = nil
    task.eqvgroup_id = 0
    task.section = nil
    task.soft_delete!
    task.reload
    task.remove_from_list
  end
end