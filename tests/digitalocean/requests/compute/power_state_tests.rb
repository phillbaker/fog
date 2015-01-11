Shindo.tests('Fog::Compute[:digitalocean] | power on/off/shutdown requests',
             ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    test('#power_off_server') do
      service.power_off_server(server.id).status == 201
    end

    test('#power_on_server') do
      service.power_on_server(server.id).status == 201
    end

    test('#shutdown_server') do
      service.shutdown_server(server.id).status == 201
    end

    server.start

  end

end
