class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column :tests, :attestation, :boolean, default: true
    change_column :tests, :training, :boolean, default: true
  end
end
