import requests, json 

def post_call(url, data, session = requests, use_json = True):
	headers = {'Content-Type': 'application/json'}
	if use_json:
		request = session.post(url, data = json.dumps(data), headers = headers)
	else:
		request = session.post(url, data = data)
	return request

url_1 = "https://cryptic-waters-12950.herokuapp.com/api/details_ifsc"
url_2 = "http://cryptic-waters-12950.herokuapp.com/api/details_bank_city"


def check_ifsc():
	data_1 = {'ifsc': 'ALLA0210054'}
	req = post_call(url_1, data_1)
	assert req.status_code == 200, True
	print req.content


def check_details():
	data = {'bank': 'ABHYUDAYA COOPERATIVE BANK LIMITED', 'city': 'MUMBAI'}
	req = post_call(url_2, data)
	assert req.status_code == 200, True
	print req.content

def check_unavailable_input():
	data = {'ifsc': 'asdf'}
	req = post_call(url_1, data)
	assert req.status_code == 403, True
	print req.content

	data = {'bank': 'bla', 'city': 'city'}
	req = post_call(url_2, data)
	assert req.status_code == 403, True
	print req.content

def check_bad_input():
	data = {'bla': 'bla'}
	req = post_call(url_1, data)
	assert req.status_code == 403, True
	print req.content

	data = {}
	req = post_call(url_2, data)
	assert req.status_code == 403, True
	print req.content

check_bad_input()


