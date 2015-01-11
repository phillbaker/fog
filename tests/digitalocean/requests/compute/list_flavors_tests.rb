Shindo.tests('Fog::Compute[:digitalocean] | list_flavors request', ['digitalocean', 'compute']) do

  @flavor_format = {
    'slug'         => String,
  }

  tests('success') do

    tests('#list_flavor') do
      flavors = service.list_flavors.body
      test 'returns a Hash' do
        flavors.is_a? Hash
      end
      tests('flavor').formats(@flavor_format, false) do
        flavors['sizes'].first
      end
    end

  end

end
