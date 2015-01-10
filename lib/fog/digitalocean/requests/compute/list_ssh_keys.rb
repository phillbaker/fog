module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_ssh_keys(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'account/keys'
          )
        end
      end

      class Mock
        def list_ssh_keys
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "ssh_keys"  => [
              {
                "id" => 512189,
                "fingerprint" => "3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa",
                "public_key" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V example",
                "name" => "My SSH Public Key"
              }
            ]
          }
          response
        end
      end
    end
  end
end
