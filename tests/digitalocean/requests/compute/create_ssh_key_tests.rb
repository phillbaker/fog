Shindo.tests('Fog::Compute[:digitalocean] | create_ssh_key request', ['digitalocean', 'compute']) do

  @key_format = {
    'id'             => Integer,
    'name'           => String,
    'public_key'    => String
  }

  tests('success') do

    tests('#create_ssh_key').formats('ssh_key' => @key_format) do
      @key = service.create_ssh_key 'fookey', 'fookey'
      @key.body
    end

  end

  service.destroy_ssh_key @key.body['ssh_key']['id']

end
