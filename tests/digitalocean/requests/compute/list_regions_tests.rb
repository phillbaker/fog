Shindo.tests('Fog::Compute[:digitalocean] | list_regions request', ['digitalocean', 'compute']) do

  @region_format = {
    'slug'         => String,
    'name'         => String,
  }

  tests('success') do

    tests('#list_regions') do
      regions = service.list_regions.body
      test 'returns a Hash' do
        regions.is_a? Hash
      end
      tests('region').formats(@region_format, false) do
        regions['regions'].first
      end
    end

  end

end
