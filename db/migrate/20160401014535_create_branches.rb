class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
    	t.string :ifsc
    	t.integer :given_bank_id
    	t.string :branch
    	t.string :address
      t.timestamps null: false
    end
  end
end
