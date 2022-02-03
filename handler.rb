#!/usr/bin/ruby

require 'httparty'
require 'openssl'
require 'jwt'

def getJWT()
  # Private key contents
  pem_location = ENV["GITHUB_APP_KEY"] ? ENV["GITHUB_APP_KEY"] : "/opt/certs/private-key.pem"
  private_key = OpenSSL::PKey::RSA.new(File.read(pem_location))

  # Generate the JWT
  payload = {
    # issued at time, 60 seconds in the past to allow for clock drift
    iat: Time.now.to_i - 60,
    # JWT expiration time (10 minute maximum)
    exp: Time.now.to_i + (10 * 60),
    # GitHub App's identifier
    iss: ENV["APP_ID"]
  }

  return JWT.encode(payload, private_key, "RS256")
end

jwt_token = getJWT()

$baseURL = 'https://api.github.com/app/installations'
$headers = { Authorization: "Bearer #{jwt_token}" }

# Get installation_id
def getInstallationID()
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

id = getInstallationID()
generateToken(id)

