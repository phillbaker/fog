module Fog
  module Compute
    class DigitalOcean
      class Real
        #
        # Delete a SSH public key from your account
        #
        def destroy_ssh_key(id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "account/keys/#{id}"
          )
        end
      end

      class Mock
        def destroy_ssh_key(id)
          response = Excon::Response.new

          if self.data[:ssh_keys].reject! { |k| k['id'] == id }
            response.status = 204
          else
            response.status = 404
          end

          response
        end
      end
    end
  end
end
