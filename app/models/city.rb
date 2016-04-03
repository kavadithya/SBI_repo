class City < ActiveRecord::Base
	has_and_belongs_to_many :banks
	has_many :branches
end
