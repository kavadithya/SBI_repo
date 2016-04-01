class AddIndex < ActiveRecord::Migration
  def change
  	add_index :branches, :ifsc, unique: true
  	add_index :cities, :name, unique: true
  	add_index :banks, :name, unique: true
  end
end
