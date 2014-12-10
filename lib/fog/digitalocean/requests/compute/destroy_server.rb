module Fog
  module Compute
    class DigitalOcean
      class Real
        def destroy_server( id )
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "droplets/#{id}"
          )
        end
      end

      class Mock
        def destroy_server( id )
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
