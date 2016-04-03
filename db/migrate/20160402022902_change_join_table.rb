class ChangeJoinTable < ActiveRecord::Migration
  def change
  	drop_table :banks_cities
  end
end
