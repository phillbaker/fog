Shindo.tests('Fog::Compute[:digitalocean] | ssh_keys collection', ['digitalocean']) do

  tests('The ssh_keys collection') do
    options = {
      :name => 'fookey',
      :public_key => ssh_public_key
    }

    key = service.ssh_keys.create(options)
    [:all, :get].each do |method|
      test("should respond to #{method}") do
        service.ssh_keys.respond_to? method
      end
    end

    tests('should have Fog::Compute::DigitalOcean::SshKey inside') do
      service.ssh_keys.each do |s|
        test { s.kind_of? Fog::Compute::DigitalOcean::SshKey }
      end
    end

    tests('should be able to get a model') do
      test('by instance id') do
        retrieved_key = service.ssh_keys.get(key.id)
        test { retrieved_key.kind_of? Fog::Compute::DigitalOcean::SshKey }
        test { retrieved_key.name == key.name }
      end
    end

    key.destroy

  end

end
