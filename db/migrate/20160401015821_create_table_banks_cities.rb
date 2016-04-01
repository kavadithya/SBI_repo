class CreateTableBanksCities < ActiveRecord::Migration
  def change
    create_table :banks_cities, id: false do |t|
    	t.references :bank, index: true
    	t.references :city, index: true
    end
  end
end
