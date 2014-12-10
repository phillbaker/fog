require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Region < Fog::Model
        identity  :id, :aliases => 'slug'
        attribute :slug
        attribute :name
      end
    end
  end
end
