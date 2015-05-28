module SoftDeletion
  extend ActiveSupport::Concern

  included do
    scope :deleted, -> { where('deleted_at IS NOT NULL') }
    scope :existing, -> { where('deleted_at IS NULL') }
  end

  class_methods do
    def soft_delete_all!(conditions = nil)
      if conditions
        where(conditions).soft_delete_all!
      else
        to_a.each {|object| object.soft_delete! }.tap { reset }
      end
    end

  end

  def soft_delete!
    transaction do
      self.deleted_at = DateTime.now
      result = self.save!
      if result && self.respond_to?(:after_soft_delete)
        self.after_soft_delete
      end
      self
    end
  end

  def restore!
    transaction do
      self.deleted_at = nil
      result = self.save!
      if result && self.respond_to?(:after_restore)
        self.after_restore
      end
      self
    end
  end

  def deleted?
    self.deleted_at.present?
  end

end