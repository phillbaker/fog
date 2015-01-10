require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Flavor < Fog::Model
        identity :id, :aliases => 'slug'

        def slug
          id
        end

        # Backwards compatible helper
        def name
          id
        end
      end
    end
  end
end
