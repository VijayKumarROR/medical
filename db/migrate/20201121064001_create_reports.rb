class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :age
      t.string :parents_name
      t.string :describe_problem
      t.float :amount
      t.integer :user_id
      t.integer :patient_id

      t.timestamps
    end
  end
end
