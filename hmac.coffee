#!/usr/bin/env coffee

###
GET /external/users/search?token=t4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs HTTP/1.1
X-Playup-Api-Key: com.playup.ios.live 52rJdo2FZeUTRdl7AAs6uf0ZBIwmuF454S72YwOxSMfJyJ2o0LR/GjoH6k46jZ8U
Authorization: MAC id="841Rt1fZsYvdpfm5GjuUGZ4K3eqizYn8",ts="1356580385",nonce="UjeWZ6hlJjBCk9TxBrezBbIxMzU2NTgwMzg1",mac="Lb6qsRcy1MTsxEuFeLV5WlTjJ5cifNnWGEI3DOLafc8="
Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3
Accept: * /*
User-Agent: Ruby
Connection: close
Host: localhost:8080
###

b2h = (s) ->
  new Buffer(s,'binary').toString('hex')

db2h = (s) ->
  console.log b2h(s)
  
crypto = require('crypto')

createTimestamp = ->
  # Date.valueOf() behaves similar to Date.to_i
  Math.floor(Date.now()/1000) # same value as Time.now.utc.to_i

urlSafeBase64 = (buffer) ->
  buffer.toString('base64').replace(/\+/g, '-').replace(/\//g,'_')
  
createNonce = (timestamp) ->
  raw = "#{crypto.randomBytes(17)}#{timestamp}"
  urlSafeBase64 new Buffer(raw)
  
createNormalizedString = (options = {}) ->
  a= [
    options.timestamp, 
    options.nonce,
    options.requestMethod,
    options.path,
    options.host,
    options.port,
    options.ext ? '\n'
  ]
  console.log a
  a.join('\n')


createSignature = (key, normalizedString) ->
  console.log "<<#{key}>>"
  console.log "<<#{normalizedString}>>"
  
  hmac = crypto.createHmac 'sha256', key
  hmac.update(normalizedString)
  console.log hmac.digest('hex')
  
  hmac = crypto.createHmac 'sha256', key
  hmac.update(normalizedString)
  hmac.digest('base64')
  
key = 'r1ul<ZBV0EyQDNOobabWllPNJn1ids_k7A8a!S;zkbT1MRLq65kHXUnlgM_Z7<dCC'

timestamp = 1356580385
nonce = 'UjeWZ6hlJjBCk9TxBrezBbIxMzU2NTgwMzg1'

normalizeString = createNormalizedString
  timestamp: timestamp
  nonce: nonce
  requestMethod: 'GET'
  path: '/external/users/search?token=t4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
  host: 'localhost'
  port: '8080'

sig = createSignature key, normalizeString

console.log 'Lb6qsRcy1MTsxEuFeLV5WlTjJ5cifNnWGEI3DOLafc8='
console.log sig
