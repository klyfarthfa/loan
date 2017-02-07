class CreateLoanApplications < ActiveRecord::Migration
  def change
    create_table :loan_applications do |t|
      t.float :loan_amount
      t.float :prop_value
      t.string :ssn
      t.string :status

      t.timestamps null: false
    end
  end
end
