module Fog
  module Compute
    class HP
      class Real

        def rebuild_server(server_id, image_ref, name, admin_pass=nil, metadata=nil, personality=nil)

          body = { 'rebuild' => {
            'imageRef' => image_ref,
            'name' => name
          }}
          body['rebuild']['adminPass'] = admin_pass if admin_pass
          body['rebuild']['metadata'] = metadata if metadata
          body['rebuild']['personality'] = personality if personality
          server_action(server_id, body, 202)
        end

      end

      class Mock

        def rebuild_server(server_id, image_ref, name, admin_pass=nil, metadata=nil, personality=nil)
          response = get_server_details(server_id)
          response.body['server']['status'] = "REBUILD"
          response.status = 202
          response
        end

      end
    end
  end
end
