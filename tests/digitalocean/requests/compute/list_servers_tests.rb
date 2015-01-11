Shindo.tests('Fog::Compute[:digitalocean] | list_servers request', ['digitalocean', 'compute']) do

  @server_format = {
    'id'             => Integer,
    'name'           => String,
    'size_slug'      => String,
    'image'          => Hash,
    'region'         => Hash,
    'features'       => Array,
    'networks'       => Hash,
    'status'         => String,
    'created_at'     => String
  }

  tests('success') do

    tests('#list_servers') do
      service.list_servers.body['droplets'].each do |server|
        tests('format').data_matches_schema(@server_format) do
          server
        end
      end
    end

  end

end
