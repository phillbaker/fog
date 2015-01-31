require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOcean
      # A DigitalOcean Droplet
      class Server < Fog::Compute::Server
        identity  :id
        attribute :name
        attribute :state, :aliases => 'status'
        attribute :memory
        attribute :vcpus
        attribute :disk
        attribute :locked
        attribute :created_at

        attr_writer :ssh_keys

        # Reboot the server (soft reboot).
        #
        # The preferred method of rebooting a server.
        def reboot
          requires :id
          service.reboot_server self.id
        end

        # Reboot the server (hard reboot).
        #
        # Powers the server off and then powers it on again.
        def power_cycle
          requires :id
          service.power_cycle_server self.id
        end

        # Shutdown the server
        #
        # Sends a shutdown signal to the operating system.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def shutdown
          requires :id
          service.shutdown_server self.id
        end

        # Power off the server
        #
        # Works as a power switch.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def stop
          requires :id
          service.power_off_server self.id
        end

        # Power on the server.
        #
        # The server consumes resources while powered on
        # so you will be charged.
        #
        # Each time a server is spun up, even if for a few seconds,
        # it is charged for an hour.
        #
        def start
          requires :id
          service.power_on_server self.id
        end

        def setup(credentials = {})
          requires :ssh_ip_address
          require 'net/ssh'

          commands = [
            %{mkdir .ssh},
            %{passwd -l #{username}},
            %{echo "#{Fog::JSON.encode(Fog::JSON.sanitize(attributes))}" >> ~/attributes.json}
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          # wait for aws to be ready
          wait_for { sshable?(credentials) }

          Fog::SSH.new(ssh_ip_address, username, credentials).run(commands)
        end

        # Creates the server (not to be called directly).
        #
        # Usually called by Fog::Collection#create
        #
        #   docean = Fog::Compute.new({
        #     :provider => 'DigitalOcean',
        #     :digitalocean_oauth_token   => 'key-here'      # your OAuth token here
        #   })
        #   docean.servers.create :name => 'foobar',
        #                     :image_id  => image_id here,
        #                     :flavor_id => flavor_id here,
        #                     :region_id => region_id here
        #
        # @return [Boolean]
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name#, :flavor_id, :image_id, :region_id #TODO
          flavor_id, image_id, region_id = attributes.values_at(:flavor_id, :image_id, :region_id)

          options = {}
          if attributes[:ssh_key_ids]
            options[:ssh_key_ids] = attributes[:ssh_key_ids]
          elsif @ssh_keys
            options[:ssh_key_ids] = @ssh_keys.map(&:id)
          end

          # options[:private_networking] = private_networking # TODO
          # options[:backups_active] =  backups_active # TODO

          data = service.create_server name,
                                       flavor_id,
                                       image_id,
                                       region_id,
                                       options
          merge_attributes(data.body['droplet'])
          true
        end

        # Destroy the server, freeing up the resources.
        #
        # DigitalOcean will stop charging you for the resources
        # the server was using.
        #
        # Once the server has been destroyed, there's no way
        # to recover it so the data is irrecoverably lost.
        #
        # IMPORTANT: As of 2013/01/31, the server must not be in the 'new'
        # state when you try to issue the destroy. You should wait until the
        # server is 'active' or 'off'. If you try to destroy the server too
        # fast, the API call will return a non-200 response and the server
        # will remain running and consuming resources, so DigitalOcean will
        # keep charging you. Double checked this with DigitalOcean staff and
        # confirmed that it's the way it works right now.
        #
        # Double check the server has been destroyed!
        def destroy
          requires :id
          service.destroy_server id
        end

        def backups_active
          #TODO fetch from features array
        end

        def public_ip_address
          public_bridge = network_bridge('public')
          public_bridge['ip_address'] if public_bridge
        end

        def private_ip_address
          private_bridge = network_bridge('private')
          private_bridge['ip_address'] if private_bridge
        end

        def status
          state
        end

        def flavor_id
          flavor.id
        end

        def region_id
          region.id
        end

        def image_id
          image.id
        end

        def flavor
          Fog::Compute::DigitalOcean::Region.new(attributes['size'])
        end

        def region
          Fog::Compute::DigitalOcean::Region.new(attributes['region'])
        end

        def image
          Fog::Compute::DigitalOcean::Region.new(attributes['image'])
        end

        # Checks whether the server status is 'active' and there are any pending events.
        #
        # The server transitions from 'new' to 'active' on create.
        #
        # @return [Boolean]
        def ready?
          Fog::Logger.warning("[DigitalOcean] #{attributes['name']} (#{attributes['id']}) ready?")
          state == 'active'
        end

        # DigitalOcean API does not support updating server state
        def update
          msg = 'DigitalOcean servers do not support updates'
          raise NotImplementedError.new(msg)
        end

        # Helper method to get an array with all available IP addresses
        def ip_addresses
          [public_ip_address, private_ip_address].flatten.select(&:present?)
        end

        protected

        def network_bridge(type)
          # require 'pry'; binding.pry
          attributes['networks']['v4'].find { |n| n['type'] == 'public' }
        end
      end
    end
  end
end
