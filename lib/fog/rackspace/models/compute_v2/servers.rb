require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Compute
    class RackspaceV2

      class Servers < Fog::Collection

        model Fog::Compute::RackspaceV2::Server

        # Returns list of servers 
        # @return [Array<Fog::Compute::RackspaceV2::Server>] Retrieves a list servers.
        # @note Fog's current implementation only returns 1000 servers
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Servers-d1e2078.html
        def all
          data = service.list_servers.body['servers']
          load(data)
        end

        # Creates a new server and populates ssh keys
        # @example
        #   service = Fog::Compute.new(:provider => 'rackspace', 
        #                             :version => :v2, 
        #                             :public_key_path => '~/.ssh/fog_rsa.pub',
        #                             :private_key_path => '~/.ssh/fog_rsa')
        #
        #   service.servers.bootstrap :name => 'bootstap-server',
        #                             :flavor_id => service.flavors.first.id
        #                             :image_id => service.servers.first.id
        #        
        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for(1500) { ready? && !ipv4_address.empty? }
          server.setup(:password => server.password)
          server
        end

        # Retrieves server
        # @param [String] server_id for server to be returned
        # @return [Fog::Compute::RackspaceV2:Server]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Server_Details-d1e2623.html
        def get(server_id)
          data = service.get_server(server_id).body['server']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
