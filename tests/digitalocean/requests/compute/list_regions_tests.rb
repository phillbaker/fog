Shindo.tests('Fog::Compute[:digitalocean] | list_regions request', ['digitalocean', 'compute']) do

  @region_format = {
    'id'           => Integer,
    'name'         => String,
  }

  tests('success') do

    tests('#list_regions') do
      # should use helper?
      regions = Fog::Compute[:digitalocean].list_regions.body
      test 'returns a Hash' do
        regions.is_a? Hash
      end
      tests('region').formats(@region_format, false) do
        regions['regions'].first
      end
    end

  end

end
