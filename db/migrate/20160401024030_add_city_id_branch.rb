class AddCityIdBranch < ActiveRecord::Migration
  def change
  	  	add_column :branches, :city_id, :integer
  	  	add_column :branches, :bank_id, :integer
  end
end
