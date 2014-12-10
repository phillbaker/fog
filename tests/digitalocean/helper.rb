
# Shortcut for Fog::Compute[:digitalocean]
def service
  Fog::Compute[:digitalocean]
end

def fog_test_server_attributes
  image = service.images.find { |i| i.slug == 'ubuntu-14-04-x64' }
  image_id = image.nil? ? 'ubuntu-14-04-x64' : image.id
  region = service.regions.find { |r| r.id == 'NYC3' }
  region_id = region.nil? ? 'NYC3' : region.id
  flavor = service.flavors.find { |f| f.id == '512MB' }
  flavor_id = flavor.nil? ? '512MB' : flavor.id

  {
    :image_id  => image_id,
    :region_id => region_id,
    :flavor_id => flavor_id
  }
end

def fog_server_name
  "fog-server-test"
end

# Create a long lived server for the tests
def fog_test_server
  server = service.servers.find { |s| s.name == fog_server_name }
  unless server
    server = service.servers.create({
      :name => fog_server_name
    }.merge(fog_test_server_attributes))
    server.wait_for { ready? }
  end
  server
end

# Destroy the long lived server
def fog_test_server_destroy
  server = service.servers.find { |s| s.name == fog_server_name }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:digitalocean_api_key].nil?
    server = service.servers.find { |s| s.name == fog_server_name }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    fog_test_server_destroy
  end
end
