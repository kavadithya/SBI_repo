class AddIndex < ActiveRecord::Migration
  def change
  	add_index :branches, :ifsc, unique: true
  	add_index :cities, :name, unique: true
  	add_index :bank, :name, unique: true
  end
end
