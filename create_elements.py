import requests, json 
import time
import csv

import Queue
import threading


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

def threaded(function):
    def wrapper(*args, **kwargs):
        threading.Thread(target=function, args=args, kwargs=kwargs).start()
    return wrapper

class requestMaker():
	def __init__(self, base_url, number_threads = 1):
		self.base_url = base_url
		self.number_threads = number_threads
		self.rows_pending = Queue.Queue()
		self.rows_current = Queue.Queue(self.number_threads)
		self.load()

	def load(self):
		count = 0
		try:
			reader = csv.reader(f)
			for row in reader:
				print count
				try:
					if count > -1: 
						self.rows_pending.put(row)
				except Exception as e:
					print "%s failed due to %s"%(row, e)
				count += 1
		finally:
			f.close()      


	@threaded
	def _makeRequest(self, row):
		print "Thread"
		make_request(row)
		self.rows_current.get()

	@threaded
	def _masterWorker(self):
		while True:
			try:
				row = self.rows_pending.get(False)
			except Exception as e:
				print "No more URLS to be done"
				break
			self.rows_current.put(row)
			self._makeRequest(row)


m = requestMaker(url, 5)
m._masterWorker()