import requests
import http.client
import urllib
import datetime 
import base64 
import hmac 
import hashlib

SHARED = 'ac283f62da8f4afcab04196fb3ac1b84'
SECRET =  '85e6595e3e8f4797a86371933fe2125e'
siteId = '815195ff68974fddbfa90e72ed59d4c6'

app_key = ''
endpoint = f'/site/sites/{siteId}'
method = ''
url = f'https://gateway-staging.ncrcloud.com{endpoint}'

headers = {
    'date': datetime.datetime.now(datetime.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %Z"), 
    'accept': 'application/json', 
    'content-type': 'application/json'
}

print("Time 1", )
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
    
    print(toSign)
    print(datetime.datetime.strptime(req.headers['date'], "%a, %d %b %Y %H:%M:%S %Z").strftime("%Y-%m-%dT%H:%M:%S.000Z"))

    key = bytes(SECRET + datetime.datetime.strptime(req.headers['date'], "%a, %d %b %Y %H:%M:%S %Z").strftime("%Y-%m-%dT%H:%M:%S.000Z"), 'utf-8')
    print(key)
    message = bytes(toSign, 'utf-8')
    print('Message', message)

    digest = hmac.new(key, msg=bytes(message), digestmod=hashlib.sha512).digest()
    signature = base64.b64encode(digest)
    return "AccessKey {}:{}".format(SHARED, signature.decode('ascii'))

prepped.headers['Authorization'] = createHMAC(prepped)

print(prepped.headers)

# res = s.send(prepped)
# print(res.text)

