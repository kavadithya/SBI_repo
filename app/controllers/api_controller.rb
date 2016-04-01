class ApiController < ApplicationController

    def new_entry
    	details = get_params
    	city = City.find_by_name(details['city'])
    	bank = Bank.find_by_name(details['bank_name'])
    	if city.nil? and bank.nil?
    		city = City.new({name: details['city'], district: details['district'], state: details['state']})
    		city.save
    		bank = city.bank.new({name: details['bank_name']})
    		bank.save
    	elsif bank.nil?
			bank = city.bank.new({name: details['bank_name']})
			bank.save
		elsif city.nil? 
			city = bank.city.new({name: details['city'], district: details['district'], state: details['state']})
			city.save
		end

		branch = city.branch.new({ifsc: details['ifsc'], 'given_bank_id': details['bank_id'], 'branch': details['branch'], 'address': details['address']})
		branch.bank_id = bank.id
		if	branch.save
			render json:{message: 'success'}, :status => 200
		end
    end

    def details_ifsc
    	branch = Branch.find_by_ifsc(params[:ifsc])
    	render json: get_branch_details(branch), :status => 200
    end

    def details_bank_city
    	bank = Bank.find_by_name(params[:bank])
    	city = City.find_by_name(params[:city])
    	branches = city.branch.where(:bank_id => bank.id)
    	list_branches = []
    	branches.each do |br|
    		list_branches.push(get_branch_details(br))
    	end
    	render json: {'list_branches': list_branches}, :status => 200
    end

	private

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

		def get_branch_details(branch)
	    	bank = Bank.find(branch.bank_id)
	    	city = City.find(branch.city_id)
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
