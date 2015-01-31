Shindo.tests('Fog::Compute[:digitalocean] | destroy_ssh_key request', ['digitalocean', 'compute']) do

  tests('success') do

    test('#destroy_ssh_key') do
      key = service.create_ssh_key('fookey', ssh_public_key)
      service.destroy_ssh_key(key.body['ssh_key']['id']).status == 204
    end

  end
end
