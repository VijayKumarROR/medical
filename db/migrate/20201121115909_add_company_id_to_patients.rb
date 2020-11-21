class AddCompanyIdToPatients < ActiveRecord::Migration[6.0]
  def change
  	add_column :patients, :company_id, :integer
  end
end
