module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_images(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'images'
          )
        end
      end

      class Mock
        def list_images
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "images" => [
              {
                "id" => 7555620,
                "name" => "Nifty New Snapshot",
                "distribution" => "Ubuntu",
                "slug" => nil,
                "public" => false,
                "regions" => [
                  "nyc2",
                  "nyc3"
                ],
                "created_at" => "2014-11-04T22:23:02Z",
                "min_disk_size" => 20
              }
            ]
          }
          response
        end
      end
    end
  end
end
