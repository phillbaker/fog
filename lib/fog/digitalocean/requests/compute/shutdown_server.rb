module Fog
  module Compute
    class DigitalOcean
      class Real
        def shutdown_server( id )
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => "droplets/#{id}/actions",
            :query    => { "type" => "shutdown" }
          )
        end
      end

      class Mock
        def shutdown_server( id )
          response = Excon::Response.new
          response.status = 201
          server = self.data[:servers].find { |s| s['id'] == id }

          # Simulate reboot
          server['status'] = 'off' if server

          response.body = {
            "action" => {
              "id" => Fog::Mock.random_numbers(1).to_i,
              "status" => "in-progress",
              "type" => "shutdown",
              "started_at" => "2014-11-04T17:08:03Z",
              "completed_at" => nil,
              "resource_id" => id,
              "resource_type" => "droplet",
              "region" => "nyc2"
            }
          }
          response
        end
      end
    end
  end
end
