class AddIndexBankId < ActiveRecord::Migration
  def change
  	  	add_index :branches, :bank_id
  end
end
