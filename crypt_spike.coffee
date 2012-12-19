crypto = require('crypto')

b2h = (s) ->
  new Buffer(s,'binary').toString('hex')

db2h = (s) ->
  console.log b2h(s)

digest = (algorithm, text) ->
  hasher = crypto.createHash(algorithm)
  hasher.update(text)
  hasher.digest('binary')

createDecipher = (secret) ->
  key = digest('sha256', secret)
  iv = digest('md5', secret)

  console.log "key, iv:"
  db2h(key)
  db2h(iv)

  iv = new Buffer(iv,'binary').toString('hex')
  iv = iv[0..15]

  crypto.createDecipheriv('aes-256-cbc', key, iv)

keys = JSON.parse """
                  {
                    "client": {
                      "id": "x8yy16FAMo4r3bEdqDWk86VPDhFBuw5G",
                      "secret": "fW_7x0nT>WCeAnxc32xSZ?JiwtST?3T900Dn73uCI-_L~by8;t3uo2zp_e+QPNz9d"
                    },
                    "server": {
                      "id": "841Rt1fZsYvdpfm5GjuUGZ4K3eqizYn8",
                      "secret": "r1ul<ZBV0EyQDNOobabWllPNJn1ids_k7A8a!S;zkbT1MRLq65kHXUnlgM_Z7<dCC"
                    }
                  }
                  """

token = "b1u2lSoDzWLgY4RoeqBTn0alyRb4ydxiavIQMjJ2FvaoeW8gHj1KYvKoSuRJ\n0n1ToEdlYu8xdI/e2UdLm+JinoNfeQBOgiXlz08uwSYgmqM=\n"

buffer = new Buffer(token, 'base64')
encrypted = buffer.toString('binary')
db2h encrypted

decipherClient = createDecipher(keys.client.secret)
decrypted = decipherClient.update encrypted, 'binary', 'binary'
db2h decrypted
decrypted += decipherClient.final 'binary'
db2h decrypted

decipherServer =  createDecipher(keys.server.secret)
decrypted = decipherServer.update decrypted, 'binary', 'binary'
db2h decrypted
decrypted += decipherServer.final 'binary'
db2h decrypted

escaped = new Buffer(decrypted, 'binary').toString('base64')
console.log escaped
escaped = encodeURI(escaped)
console.log escaped
