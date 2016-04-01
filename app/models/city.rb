class City < ActiveRecord::Base
	has_and_belongs_to_many :bank
	has_many :branch
end
