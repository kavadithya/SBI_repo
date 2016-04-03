class Bank < ActiveRecord::Base
	has_and_belongs_to_many :cities
	has_many :branches
end
