Shindo.tests('Fog::Compute[:digitalocean] | shutdown_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    tests('#shutdown_server').succeeds do
      service.shutdown_server(server.id).status == 201
    end

  end

end
