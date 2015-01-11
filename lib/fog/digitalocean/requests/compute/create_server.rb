module Fog
  module Compute
    class DigitalOcean
      class Real
        def create_server( name,
                           size_id,
                           image_id,
                           region_id,
                           options = {} )

          query_hash = {
            :name        => name,
            :size        => size_id,
            :image       => image_id,
            :region      => region_id
          }

          if options[:ssh_key_ids]
            options[:ssh_key_ids]    = options[:ssh_key_ids].join(",") if options[:ssh_key_ids].is_a? Array
            query_hash[:ssh_keys]    = options[:ssh_key_ids]
          end

          query_hash[:private_networking] = !!options[:private_networking]
          query_hash[:ipv6] = !!options[:ipv6]
          query_hash[:backups] = !!options[:backups_active]
          query_hash[:user_data] = options[:user_data]

          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => 'droplets',
            :query    => query_hash
          )
        end
      end

      class Mock
        def create_server( name,
                           size_id,
                           image_id,
                           region_id,
                           options = {} )
          response = Excon::Response.new
          response.status = 200

          has_private_ip = !!options[:private_networking]
          # TODO other options: sshkeys, ipv6, backups, user data

          bridges = [
            {
              "ip_address" => "104.131.186.241",
              "netmask" => "255.255.240.0",
              "gateway" => "104.131.176.1",
              "type" => "public"
            }
          ]
          if has_private_ip
            bridges << {
              "type" => "private",
              "gateway" => "10.131.0.1",
              "netmask" => "255.255.0.0",
              "ip_address" => "10.131.251.211"
            }
          end

          mock_data = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "event_id" => Fog::Mock.random_numbers(2).to_i,
            "name" => name,
            "size_id" => size_id,
            "image_id" => image_id,
            "region_id" => region_id,
            "created_at" => Time.now.strftime("%FT%TZ"),
            "memory" => 512,
            "vcpus" => 1,
            "disk" => 20,
            "locked" => true,
            "status" => "active",
            "kernel" => {
              "id" => 2233,
              "name" => "Ubuntu 14.04 x64 vmlinuz-3.13.0-37-generic",
              "version" => "3.13.0-37-generic"
            },
            "features" => [
              # TODO
              # "virtio",
              # "private_networking",
              # "backups",
              # "ipv6",
              # "metadata"
            ],
            "backup_ids" => [],
            "snapshot_ids" => [],
            "image" => {},
            "size" => "512mb",
            "networks" => {
              "v4" => bridges,
              "v6" => [
                {
                  "ip_address" => "2604:A880:0800:0010:0000:0000:031D:2001",
                  "netmask" => 64,
                  "gateway" => "2604:A880:0800:0010:0000:0000:0000:0001",
                  "type" => "public"
                }
              ]
            },
            "region" => {
            }
          }

          response.body = {
            "droplet"  => mock_data
          }

          self.data[:servers] << mock_data
          response
        end
      end
    end
  end
end
