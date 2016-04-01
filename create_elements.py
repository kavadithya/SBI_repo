import requests, json 
import time
import csv

url = "https://cryptic-waters-12950.herokuapp.com/api/new_entry"
f = open('bank_branches.csv', 'rb')

def post_call(url, data, session = requests, use_json = True):
	headers = {'Content-Type': 'application/json'}
	if use_json:
		request = session.post(url, data = json.dumps(data), headers = headers)
	else:
		request = session.post(url, data = data)
	return request


def make_request(list):
	data = {'ifsc': list[0], 'bank_id': list[1], 'branch': list[2], 'address': list[3], \
			'city': list[4], 'district': list[5], 'state': list[6], 'bank_name': list[7]}
	req = post_call(url, data)
	if req.status_code == 200:
		return True
	return False

count = 0
try:
	reader = csv.reader(f)
	for row in reader:
		print count
		try:
			make_request(row)
		except Exception as e:
			print "%s failed due to %s"%(row, e)
		count += 1
finally:
	f.close()      



# data = {'ifsc': 'iasdf2', 'bank_id': 60, 'branch': 'branch', 'address': 'address',\
# 		'city': 'city', 'district': 'district', 'state': 'state', 'bank_name': 'ICICI'}


