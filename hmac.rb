#!/usr/bin/env ruby

require 'openssl'
require 'base64'

def wl(string)
  puts string.unpack("H*")
end

key = "r1ul<ZBV0EyQDNOobabWllPNJn1ids_k7A8a!S;zkbT1MRLq65kHXUnlgM_Z7<dCC"

timestamp = 1356580385
nonce = "UjeWZ6hlJjBCk9TxBrezBbIxMzU2NTgwMzg1"

class NormalizedString
    def initialize(options = {})
    @timestamp = options[:timestamp]
    @nonce = options[:nonce]
    @request_method = options[:request_method]
    @path = options[:path]
    @host = options[:host]
    @port = options[:port]
    @ext = options[:ext] || "\n"
  end

  def to_s
    a = [@timestamp, @nonce, @request_method, @path, @host, @port, @ext]
    p a
    a.join("\n")
  end
end

class Signature
   ALGORITHMS = {'hmac-sha-256' => 'sha256', 'hmac-sha-1' => 'sha1'}
  DEFAULT_ALGORITHM = 'hmac-sha-256'

  def initialize(key, data, algorithm = DEFAULT_ALGORITHM)
    @algorithm = algorithm
    @data = data
    @key = key
  end

  def to_s
    tmp = OpenSSL::HMAC.digest(digest, @key, @data)
    puts "<<#{@key}>>"
    puts "<<#{@data}>>"
    wl tmp
    Base64.strict_encode64(tmp)
  end

  def matches?(base64_expected_signature)
    to_s == base64_expected_signature
  end

  private

  def digest
    digest_algorithm = @algorithm ? ALGORITHMS[@algorithm] : ALGORITHMS[DEFAULT_ALGORITHM]
    OpenSSL::Digest::Digest.new(digest_algorithm)
  end
end

normalized_string = NormalizedString.new( timestamp: timestamp,
                                          nonce: nonce,
                                          request_method: 'GET',
                                          path: '/external/users/search?token=t4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs',
                                          host: 'localhost',
                                          port: 8080).to_s                                         

s = Signature.new(key, normalized_string).to_s                                          

puts "Lb6qsRcy1MTsxEuFeLV5WlTjJ5cifNnWGEI3DOLafc8="
puts s
