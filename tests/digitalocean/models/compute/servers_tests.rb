Shindo.tests('Fog::Compute[:digitalocean] | servers collection', ['digitalocean']) do
  def unique_server_options
    {
      :name => "#{fog_server_name}-#{Time.now.to_i}"
    }.merge(fog_test_server_attributes)
  end

  collection_tests(service.servers, unique_server_options, true) do
    @instance.wait_for { ready? }
  end

  tests("#bootstrap with public/private_key").succeeds do
    options = unique_server_options

    if Fog.mocking?
      options.merge!(:public_key => "foo", :private_key => "bar")
    end

    @server = service.servers.bootstrap(options)
    @server.destroy
  end

  tests("#bootstrap with public/private_key_path") do
    tests("#bootstrap with non-existent paths") do
      options = unique_server_options
      if Fog.mocking?
        options.merge!(:public_key_path => "~/.ssh/#{Time.now.to_i}.pub", :private_key_path => "~/.ssh/#{Time.now.to_i}")
      end

      raises(Errno::ENOENT, 'raises No such file or directory') do
        @server = service.servers.bootstrap(options)
        @server.destroy
      end
    end

    tests("#bootstrap succeeds").succeeds do
      pending if Fog.mocking? # Requires credentials in a .fog config
      @server = service.servers.bootstrap(unique_server_options)
      @server.destroy
    end
  end

  tests("#bootstrap with no public/private keys") do
    raises(ArgumentError, 'raises ArgumentError') { service.servers.bootstrap(unique_server_options) }
  end
end
