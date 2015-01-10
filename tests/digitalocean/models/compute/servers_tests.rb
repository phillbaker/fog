Shindo.tests('Fog::Compute[:digitalocean] | servers collection', ['digitalocean']) do
  options = {
    :name => "#{fog_server_name}-#{Time.now.to_i}"
  }.merge(fog_test_server_attributes)

  collection_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
  end

  tests("#bootstrap with public/private_key_path").succeeds do
    if Fog.mocking?
      options.merge!(:public_key_path => "~/.ssh/fog_rsa.pub", :private_key_path => "~/.ssh/fog_rsa")
    end

    @server = service.servers.bootstrap(options)
    @server.destroy
  end

  tests("#bootstrap with public/private_key").succeeds do
    if Fog.mocking?
      options.merge!(:public_key => "foo", :private_key => "bar")
    end

    @server = service.servers.bootstrap(options)
    @server.destroy
  end

  tests("#bootstrap with no public/private keys") do
    raises(ArgumentError, 'raises ArgumentError') { service.servers.bootstrap(options) }
  end
end
