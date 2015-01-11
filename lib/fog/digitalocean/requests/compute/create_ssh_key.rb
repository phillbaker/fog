module Fog
  module Compute
    class DigitalOcean
      class Real
        def create_ssh_key( name, pub_key )
          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => 'account/keys',
            :query    => { 'name' => name, 'public_key' => pub_key }
          )
        end
      end

      class Mock
        def create_ssh_key( name, pub_key )
          response = Excon::Response.new
          response.status = 200
          mock_data = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "name" => name,
            "fingerprint" => Fog::Mock.random_numbers(10).to_i,
            "public_key" => pub_key
          }
          response.body = {
            "ssh_key"  => mock_data
          }
          self.data[:ssh_keys] << mock_data
          response
        end
      end
    end
  end
end
