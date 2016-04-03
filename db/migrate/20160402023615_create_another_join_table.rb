class CreateAnotherJoinTable < ActiveRecord::Migration
  def change
   create_table :banks_cities, :id => false do |t|
      t.integer :city_id, index: true
      t.integer :bank_id, index: true
    end
  end
end
