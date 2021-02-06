import requests
import http.client
import urllib
import datetime 
import base64 
import hmac 
import hashlib

SHARED = '63f4fc90aed9413d804f5db9ce93dd41'
SECRET =  '0bcc54040c394945815ffd675f9ab7ae'

app_key = '8445504c61bb4b0eaa74c304c06d0a9c'

method = ''
url = 'https://gateway-staging.ncrcloud.com/cdm/consumers-metadata'

headers = {
    'date': datetime.datetime.now(datetime.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %Z"), 
    'accept': 'application/json', 
    'content-type': 'application/json'
}
request = requests.Request('GET', url, headers=headers)
prepped = request.prepare()

s = requests.Session()


def createHMAC(req): #takes a prepped request and creates the HMAC header for authorization
    toSign = req.method + "\n" + urllib.parse.urlsplit(req.url).path

    hmac_headers = [
        'content-type', 
        'content-md5', 
        'nep-application-key', 
        'nep-correlation-id', 
        'nep-organization',
        'nep-service-version', 
    ]


    for header in request.headers.keys():
        if header in hmac_headers: 
            toSign += '\n' + req.headers[header] 

    key = bytes(SECRET + datetime.datetime.strptime(req.headers['date'], "%a, %d %b %Y %H:%M:%S %Z").strftime("%Y-%m-%dT%H:%M:%S.000Z"), 'utf-8')

    message = bytes(toSign, 'utf-8')

    digest = hmac.new(key, msg=bytes(message), digestmod=hashlib.sha512).digest()
    signature = base64.b64encode(digest)
    return "AccessKey {}:{}".format(SHARED, signature.decode('ascii'))


prepped.headers['Authorization'] = createHMAC(prepped)
s.send(prepped)