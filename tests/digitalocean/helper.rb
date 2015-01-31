
# Shortcut for Fog::Compute[:digitalocean]
def service
  Fog::Compute[:digitalocean]
end

def ssh_public_key
  'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1SL+kgze8tvSFW6Tyj3RyZc9iFVQDiCKzjgwn2tS7hyWxaiDhjfY2mBYSZwFdKN+ZdsXDJL4CPutUg4DKoQneVgIC1zuXrlpPbaT0Btu2aFd4qNfJ85PBrOtw2GrWZ1kcIgzZ1mMbQt6i1vhsySD2FEj+5kGHouNxQpI5dFR5K+nGgcTLFGnzb/MPRBk136GVnuuYfJ2I4va/chstThoP8UwnoapRHcBpwTIfbmmL91BsRVqjXZEUT73nxpxFeXXidYwhHio+5dXwE0aM/783B/3cPG6FVoxrBvjoNpQpAcEyjtRh9lpwHZtSEW47WNzpIW3PhbQ8j4MryznqF1Rhw=='
end

def fog_test_server_attributes
  image = service.images.find { |i| i.slug == 'ubuntu-14-04-x64' }
  image_id = image.nil? ? 'ubuntu-14-04-x64' : image.id
  region = service.regions.find { |r| r.id == 'fra1' }
  region_id = region.nil? ? 'nyc3' : region.id
  flavor = service.flavors.find { |f| f.id == '512mb' }
  flavor_id = flavor.nil? ? '512mb' : flavor.id

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
    server.wait_for do
      reload rescue nil; !server.locked
    end
  end
  server
end

# Destroy the long lived server
def fog_test_server_destroy
  server = service.servers.reload.find { |s| s.name == fog_server_name }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:digitalocean_oauth_token].nil?
    server = service.servers.find { |s| s.name == fog_server_name }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    fog_test_server_destroy
  end
end
