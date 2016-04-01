import requests, json 

def post_call(url, data, session = requests, use_json = True):
	headers = {'Content-Type': 'application/json'}
	if use_json:
		request = session.post(url, data = json.dumps(data), headers = headers)
	else:
		request = session.post(url, data = data)
	return request

prod_url_1 = "https://cryptic-waters-12950.herokuapp.com/api/details_ifsc"

url_1 = "http://localhost/api/details_ifsc"
data_1 = {'ifsc': 'ALLA0210054'}

url_2 = "http://cryptic-waters-12950.herokuapp.com/api/details_bank_city"
data_2 = {'bank': 'ABHYUDAYA COOPERATIVE BANK LIMITED', 'city': 'MUMBAI'}

# req = post_call(prod_url_1, data_1)
req = post_call(url_2, data_2)
print req.status_code

print req.content


