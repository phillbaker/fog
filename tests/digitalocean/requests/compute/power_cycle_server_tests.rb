Shindo.tests('Fog::Compute[:digitalocean] | power_cycle_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    tests('#power_cycle_server') do
      test('returns 201') do
        service.power_cycle_server(server.id).status == 201
      end
    end

  end

end
