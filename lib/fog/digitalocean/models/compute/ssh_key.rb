module Fog
  module Compute
    class DigitalOcean
      class SshKey < Fog::Model
        identity :id

        attribute :name
        attribute :public_key

        def save
          requires :name, :public_key

          merge_attributes(service.create_ssh_key(name, public_key).body['ssh_key'])
          true
        end

        def destroy
          requires :id

          service.destroy_ssh_key id
          true
        end
      end
    end
  end
end
