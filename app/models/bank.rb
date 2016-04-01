class Bank < ActiveRecord::Base
	has_and_belongs_to_many :city
	has_many :branch
end
