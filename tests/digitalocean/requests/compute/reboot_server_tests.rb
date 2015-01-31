Shindo.tests('Fog::Compute[:digitalocean] | reboot_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    tests('#reboot_server').succeeds do
      service.reboot_server(server.id).status == 201
    end

  end

end
