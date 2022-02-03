#!/usr/bin/ruby

require 'httparty'
require 'openssl'
require 'jwt'

def getJWT()
  # Private key contents
  private_pem = File.read(ENV["GITHUB_APP_KEY"])
  private_key = OpenSSL::PKey::RSA.new(private_pem)

  # Set token expiration
  expire_after = (ENV["EXPIRATION"] ? ENV["EXPIRATION"] : "10").to_i

  # Generate the JWT
  payload = {
    # issued at time, 60 seconds in the past to allow for clock drift
    iat: Time.now.to_i - 60,
    # JWT expiration time (10 minute maximum by default)
    exp: Time.now.to_i + (expire_after * 60),
    # GitHub App's identifier
    iss: ENV["APP_ID"]
  }

  return JWT.encode(payload, private_key, "RS256")
end

$baseURL = 'https://api.github.com/app/installations'
$headers = { Authorization: "Bearer #{getJWT()}" }

# Get installation_id
def getInstallationID(jwt)
  response = HTTParty.get($baseURL, headers: $headers)
  id = JSON.parse(response.body)[0]["id"] if response.code == 200
  return id
end

# Generate auth token
def generateToken(id)
  response = HTTParty.post("#{$baseURL}/#{id}/access_tokens", headers: $headers)
  result = JSON.parse(response.body)
  print result["token"]
  STDOUT.flush
end

id = getInstallationID(getJWT())
generateToken(id)

