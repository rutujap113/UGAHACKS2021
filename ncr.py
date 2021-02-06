import requests
import urllib
import datetime 
import base64 
import hmac 
import hashlib
import json

SHARED = '63f4fc90aed9413d804f5db9ce93dd41'
SECRET =  '0bcc54040c394945815ffd675f9ab7ae'
# app_key = '8445504c61bb4b0eaa74c304c06d0a9c'

def createHMAC(req): 
    toSign = req.method + "\n" + urllib.parse.urlsplit(req.url).path

    hmac_headers = [
        'content-type', 
        'content-md5', 
        'nep-application-key', 
        'nep-correlation-id', 
        'nep-organization',
        'nep-service-version', 
    ]

    for header in req.headers.keys():
        if header in hmac_headers: 
            toSign += '\n' + req.headers[header] 

    key = bytes(SECRET + datetime.datetime.strptime(req.headers['date'], "%a, %d %b %Y %H:%M:%S %Z").strftime("%Y-%m-%dT%H:%M:%S.000Z"), 'utf-8')

    message = bytes(toSign, 'utf-8')

    digest = hmac.new(key, msg=bytes(message), digestmod=hashlib.sha512).digest()
    signature = base64.b64encode(digest)
    return "AccessKey {}:{}".format(SHARED, signature.decode('ascii'))

class NCRRequester(): 
    def __init__(self, shared=SHARED, secret=SECRET):
        self.sess = requests.Session()
        self.baseURL = 'https://gateway-staging.ncrcloud.com{}'
        self.site_id = 'de0ebf8075484018af65c4eb6e9c462d'
    
    def make_headers(self, headers):
        headers['date'] = datetime.datetime.now(datetime.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %Z")
        headers['accept'] = 'application/json'
        headers['content-type'] = 'application/json'
        headers['nep-organization'] = '992ac8ce56fa4e30b3eb3367dc2c3693'
        headers['nep-enterprise-unit'] = 'de0ebf8075484018af65c4eb6e9c462d'
        return headers 

    def send(self, req):
        preparedRequest = req.prepare()
        preparedRequest.headers['Authorization'] = createHMAC(preparedRequest)
        return self.sess.send(preparedRequest)

    def get(self, endpoint, headers={}): 
        headers = self.make_headers(headers)
        request = requests.Request('GET', endpoint, headers=headers)
        return self.send(request)

    def post(self, endpoint, body, headers={}):
        headers = self.make_headers(headers)
        request = requests.Request('POST', endpoint, headers=headers, data=json.dumps(body))
        return self.send(request)

    def put(self, endpoint, body, headers={}):
        headers = self.make_headers(headers)
        request = requests.Request('PUT', endpoint, headers=headers, data=json.dumps(body))
        return self.send(request)
    
    def getItems(self):
        return self.get('https://gateway-staging.ncrcloud.com/catalog/items')
    
    def getOrders(self):
        res =  self.post('https://gateway-staging.ncrcloud.com/order/3/orders/1/find', body={}).json()
        return [order['comments'] for order in res['pageContent']]  

ncr = NCRRequester()


