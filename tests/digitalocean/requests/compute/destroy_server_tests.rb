Shindo.tests('Fog::Compute[:digitalocean] | destroy_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    test('#destroy_server') do
      service.destroy_server(server.id).status == 204
    end

  end
end
