require 'fog/digitalocean/core'

module Fog
  module Compute
    class DigitalOcean < Fog::Service
      LOCKED_RESPONSE_CODE = 422

      requires     :digitalocean_oauth_token

      recognizes   :digitalocean_api_url

      model_path   'fog/digitalocean/models/compute'
      model        :server
      collection   :servers
      model        :flavor
      collection   :flavors
      model        :image
      collection   :images
      model        :region
      collection   :regions
      model        :ssh_key
      collection   :ssh_keys

      request_path 'fog/digitalocean/requests/compute'
      request      :list_servers
      request      :list_images
      request      :list_regions
      request      :list_flavors
      request      :get_server_details
      request      :create_server
      request      :destroy_server
      request      :reboot_server
      request      :power_cycle_server
      request      :power_off_server
      request      :power_on_server
      request      :shutdown_server
      request      :list_ssh_keys
      request      :create_ssh_key
      request      :get_ssh_key
      request      :destroy_ssh_key

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers => [],
              :ssh_keys => []
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @digitalocean_oauth_token = options[:digitalocean_oauth_token]
        end

        def data
          self.class.data[@digitalocean_oauth_token]
        end

        def reset_data
          self.class.data.delete(@digitalocean_oauth_token)
        end
      end

      class Real
        def initialize(options={})
          @digitalocean_oauth_token   = options[:digitalocean_oauth_token]
          @digitalocean_api_version   = options[:digitalocean_api_version] || "v2"
          Fog::Logger.deprecation("DigitalOcean API v1 is deprecated. Please upgrade to v2.") unless @digitalocean_api_version == "v2"
          @digitalocean_api_url       = options[:digitalocean_api_url] || \
                                            "https://api.digitalocean.com/"

          @connection                 = Fog::XML::Connection.new(@digitalocean_api_url)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Bearer #{@digitalocean_oauth_token.strip}",
            'Content-Type' => 'application/json'
          })

          # Prefix route with version
          params[:path] = "#{@digitalocean_api_version}/#{params[:path]}"

          # If a droplet is locked by a pending action, block while retrying
          # the action create
          response = retry_event_lock { parse @connection.request(params) }

          if response.status == 404
            raise Fog::Errors::NotFound.new
          elsif response.status >= 400
            raise Fog::Errors::Error.new(response.body['message'])
          end

          response
        end

        private

        def parse(response)
          return response if response.body.empty?
          response.body = Fog::JSON.decode(response.body)
          response
        end

        # An exponential backoff to try scheduling the event after a pending
        # event is finished - a total of about 6.5 minutes.
        def retry_event_lock
          count   = 0
          response = nil
          while count < 10
            response = yield

            if response && response.status == LOCKED_RESPONSE_CODE && response.body && response.body['message'] =~ /Droplet already has a pending event/i
              count += 1
              backoff = count ** 2
              Fog::Logger.warning("Existing event for the droplet, waiting for #{backoff} seconds")
              sleep(backoff)
            else
              break
            end
          end

          response
        end
      end
    end
  end
end
