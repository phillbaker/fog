module Fog
  module Compute
    class DigitalOcean
      class Real
        def destroy_server(id)
          request(
            :expects  => [204, DigitalOcean::LOCKED_RESPONSE_CODE],
            :method   => 'DELETE',
            :path     => "droplets/#{id}"
          )
        end
      end

      class Mock
        def destroy_server(id)
          response = Excon::Response.new
          response.status = 204

          self.data[:servers].reject! { |s| s['id'] == id }

          response
        end
      end
    end
  end
end
