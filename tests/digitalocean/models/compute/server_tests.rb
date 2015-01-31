Shindo.tests("Fog::Compute[:digitalocean] | server model", ['digitalocean', 'compute']) do

  server  = fog_test_server

  tests('The server model should') do

    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{
        shutdown
        reboot
        power_cycle
        stop
        start
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end

    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [
        :id,
        :name,
        :state,
        :backups_active,
        :public_ip_address,
        :private_ip_address,
        :flavor_id,
        :region_id,
        :image_id,
        :created_at,
        :ssh_keys=
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end

    # Test server power commands. Rebooting a Droplet in quick succession can
    # throw off its ACPI state, so we destroy and recreate midway through.

    test('#reboot') do
      server.reboot
      server.wait_for { !server.locked }
      server.state == 'active'
    end

    test('#power_cycle') do
      server.power_cycle
      server.wait_for { !server.locked }
      server.state == 'active'
    end

    server.destroy
    server = fog_test_server

    test('#stop') do
      server.stop
      server.wait_for { !server.locked }
      server.state == 'off'
    end

    test('#start') do
      server.start
      server.wait_for { !server.locked }
      server.ready?
    end

    test('#shutdown') do
      server.shutdown
      server.wait_for { !server.locked }
      server.state == 'off'
    end

    test('#update') do
      begin
        server.update
      rescue NotImplementedError => e
        true
      end
    end
  end

  # restore server state
  server.start if !server.ready?
  server.wait_for { ready? && !server.locked }

end
