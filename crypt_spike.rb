#!/usr/bin/env ruby

require 'openssl'
require 'base64'
require 'json'
require 'cgi'

def wl(string)
  puts string.unpack("H*")
end

def create_decipher(secret)
  key = Digest::SHA256.digest(secret)
  p 'key, iv'
  wl key
  iv = Digest::MD5.hexdigest(secret)
  p iv
  OpenSSL::Cipher::AES256.new(:CBC).tap do |decipher|
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
  end
end

keys = JSON.parse <<-EOJSON
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
EOJSON

token = "b1u2lSoDzWLgY4RoeqBTn0alyRb4ydxiavIQMjJ2FvaoeW8gHj1KYvKoSuRJ\n0n1ToEdlYu8xdI/e2UdLm+JinoNfeQBOgiXlz08uwSYgmqM=\n"
encrypted = Base64.decode64(token)
wl encrypted

decipher_client = create_decipher(keys['client']['secret'])
decrypted = decipher_client.update encrypted
wl decrypted
decrypted += decipher_client.final
wl decrypted

decipher_server =  create_decipher(keys['server']['secret'])
decrypted = decipher_server.update decrypted
wl decrypted
decrypted += decipher_server.final
wl decrypted

escaped = Base64.encode64 decrypted
p escaped
escaped = CGI::escape(escaped)
p escaped

#puts Digest::MD5.hexdigest("secret")
#puts wl( Digest::MD5.digest("secret"))