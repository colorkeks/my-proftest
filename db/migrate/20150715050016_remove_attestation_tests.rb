class RemoveAttestationTests < ActiveRecord::Migration
  def change
    if User.column_names.include?('attestation_tests')
      remove_column :users, :attestation_tests
    end
  end
end
