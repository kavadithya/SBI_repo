class Branch < ActiveRecord::Base
	belongs_to :city
	belongs_to :bank
end
