class ApiController < ApplicationController

	def home
	end

	def get_branches
		details = get_params
		if !details['ifsc'].nil?
			message, status = Rails.cache.fetch(['ifsc', details['ifsc']], :expires_in => 24.hours) { details_ifsc(details) }
		elsif !(details['city'].nil? and details['bank'].nil?)
			message, status = Rails.cache.fetch(['bank_city', details['bank'], details['city']], :expires_in => 24.hours) { details_bank_city(details) }
		else
			message, status = {message: "Incorrect or insufficient parameters"}, 400
		end
		render json: message, :status => status
	end

    def new_entry
    	details = get_params
    	city = City.find_by_name(details['city'])
    	bank = Bank.find_by_name(details['bank_name'])
    	if city.nil? and bank.nil?
    		city = City.new({name: details['city'], district: details['district'], state: details['state']})
    		city.save
    		bank = city.banks.new({name: details['bank_name']})
    		bank.cities.push(city)
    		bank.save
    	elsif bank.nil?
			bank = city.banks.new({name: details['bank_name']})
			bank.cities.push(city)
			bank.save
		elsif city.nil? 
			city = bank.cities.new({name: details['city'], district: details['district'], state: details['state']})
			city.banks.push(bank)
			city.save
		else
			if !city.banks.include? (bank)
				city.banks.push(bank)
			end
			if !bank.cities.include? (city)
				bank.cities.push(city)
			end
		end

		branch = city.branches.new({ifsc: details['ifsc'], 'given_bank_id': details['bank_id'], 'branch': details['branch'], 'address': details['address']})
		branch.bank_id = bank.id
		if	branch.save
			render json:{message: 'success'}, :status => 200
		end
    end

	private

	    def details_ifsc(details)
	    	### Caching here is redundant - done at the previous level
	    	branch = Branch.find_by_ifsc(details['ifsc'])
	    	if branch.nil?
	    		return  {message: 'Branch not found'}, 404
	    	else
	    		return get_branch_details(branch), 200
	    	end
	    end

	    def details_bank_city(details)
	    	bank = Rails.cache.fetch(details['bank_name'], :expires_in => 24.hours) { Bank.find_by_name(details['bank_name']) }
	    	if !bank.nil?
	    		city = Rails.cache.fetch([details['bank_name'], details['city']], :expires_in => 24.hours) { bank.cities.find_by_name(details['city']) }
	    	end
	    	if bank.nil? or city.nil? 
	    		return {message: 'Branch not found'}, 404
	    	else
	    		### Caching here is redundant - done at the previous level
		    	branches = city.branches.where(:bank_id => bank.id)
		    	list_branches = []
		    	branches.each do |br|
		    		if not br.nil?
		    			list_branches.push(get_branch_details(br, bank, city))
		    		end
		    	end
		    	return {'list_branches': list_branches}, 200
		    end
	    end

		def get_params
			return {'ifsc' => params['ifsc'], 
					'bank_id' => params['bank_id'], 
					'branch' => params['branch'], 
					'address' => params['address'],
					'city' => params['city'],
					'district' => params['district'],
					'state' => params['state'],
					'bank_name' => params['bank_name']
				}
		end

		def get_branch_details(branch, bank = nil, city = nil)
			if bank.nil?
	    		bank = Rails.cache.fetch(['bank_id', branch.bank_id], :expires_in => 24.hours) { Bank.find(branch.bank_id) }
	    	end
	    	if city.nil? 
	    		city = Rails.cache.fetch(['city_id', branch.city_id], :expires_in => 24.hours) { City.find(branch.city_id) }
	    	end
	    	return {
	    		'ifsc': branch.ifsc, 
	    		'bank_id': branch.given_bank_id, 
	    		'branch': branch.branch,
	    		'address': branch.address,
	    		'city': city.name, 
	    		'district': city.district, 
	    		'state': city.state, 
	    		'bank_name': bank.name
	    		}
		end
end
