import requests, json 

BASE_URL = "http://localhost"
#BASE_URL = "https://cryptic-waters-12950.herokuapp.com"

def get_call(url):
	request = requests.get(url)
	return request

def check_ifsc():
	url = "%s/api/get_branches?ifsc=ABHY0065001"%(BASE_URL)
	req = get_call(url)
	assert req.status_code == 200, True
	print req.content


def check_details():
	url = "%s/api/get_branches?bank_name=ABHYUDAYA%%20COOPERATIVE%%20BANK%%20LIMITED&city=MUMBAI"%(BASE_URL)
	req = get_call(url)
	assert req.status_code == 200, True
	print req.content

def check_unavailable_input():
	url = "%s/api/get_branches?ifsc=1234"%(BASE_URL)
	req = get_call(url)
	assert req.status_code == 404, True
	print req.content

	url = "%s/api/get_branches?bank_name=ABHYUDAYA%%20COOPERATIVE%%20BANK%%20LIMITED&city=bla_bla"%(BASE_URL)
	req = get_call(url)
	assert req.status_code == 404, True
	print req.content

def check_bad_input():
	url = "%s/api/get_branches?abc=123"%(BASE_URL)
	req = get_call(url)
	assert req.status_code == 400, True
	print req.content

check_ifsc()
check_details()
check_unavailable_input()
check_bad_input()
