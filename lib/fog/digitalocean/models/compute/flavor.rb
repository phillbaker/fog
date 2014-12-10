require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Flavor < Fog::Model
        identity :id, :aliases => 'slug'
        attribute :name, :aliases => 'slug'
        attribute :slug
      end
    end
  end
end
