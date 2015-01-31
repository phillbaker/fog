Shindo.tests('Fog::Compute[:digitalocean] | create_server request', ['digitalocean', 'compute']) do

  @server_format = {
    'id'             => Integer,
    'name'           => String,
    'size_slug'      => String,
    'image'          => Hash, # Nested objects
    'region'         => Hash
  }

  tests('success') do

    tests('#create_server').formats('droplet' => @server_format) do
      data = service.create_server(
        fog_server_name,
        fog_test_server_attributes[:flavor_id],
        fog_test_server_attributes[:image_id],
        fog_test_server_attributes[:region_id]
      )

      data.body
    end
  end
end
