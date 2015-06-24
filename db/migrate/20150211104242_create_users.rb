class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :second_name
      t.text 'attestation_tests'
      t.string :last_name
      t.string :job

      t.timestamps
    end
  end
end
