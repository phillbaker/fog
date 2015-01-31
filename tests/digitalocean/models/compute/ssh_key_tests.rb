Shindo.tests("Fog::Compute[:digitalocean] | ssh_key model", ['digitalocean', 'compute']) do

  tests('The ssh_key model should') do

    test('#save') do
      options = {
        :name => 'fookey',
        :public_key => ssh_public_key
      }

      @key = service.ssh_keys.create(options)
      @key.is_a? Fog::Compute::DigitalOcean::SshKey
    end

    tests('have the action') do
      test('reload') { @key.respond_to? 'reload' }
      %w{
        save
        destroy
      }.each do |action|
        test(action) { @key.respond_to? action }
      end
    end

    tests('have attributes') do
      attributes = [
        :id,
        :name,
        :public_key
      ]

      tests("The key model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { @key.respond_to? attribute }
        end
      end
    end

    test('#destroy') do
      @key.destroy
    end

  end

end
