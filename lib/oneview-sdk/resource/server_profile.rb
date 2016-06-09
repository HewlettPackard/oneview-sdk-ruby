module OneviewSDK
  # Server profile resource implementation
  class ServerProfile < Resource
    BASE_URI = '/rest/server-profiles'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'ServerProfileV5'
    end

    def create
    end

    # Sets the Server Hardware for the resource
    # @param [OneviewSDK::ServerHardware] server_hardware Server Hardware resource
    def set_server_hardware(server_hardware)
      self['serverHardwareUri'] = server_hardware['uri'] if server_hardware['uri'] || server_hardware.retrieve!
      fail "Resource #{server_hardware['name']} could not be found!" unless server_hardware['uri']
    end

    # Sets the Server Hardware Type for the resource
    # @param [OneviewSDK::ServerHardwareType] server_hardware_type Type of the desired Server Hardware
    def set_server_hardware_type(server_hardware_type)
      self['serverHardwareTypeUri'] = server_hardware_type['uri'] if server_hardware_type['uri'] || server_hardware_type.retrieve!
      fail "Resource #{server_hardware_type['name']} could not be found!" unless server_hardware_type['uri']
    end

    # Sets the Enclosure Group for the resource
    # @param [OneviewSDK::EnclosureGroup] enclosure_group Enclosure Group that the Server is a member
    def set_enclosure_group(enclosure_group)
      self['enclosureGroupUri'] = enclosure_group['uri'] if enclosure_group['uri'] || enclosure_group.retrieve!
      fail "Resource #{enclosure_group['name']} could not be found!" unless enclosure_group['uri']
    end

    # Get all the available Ethernet and FC Networks
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [String] 'function_type' The FunctionType (Ethernet or FibreChannel) to filter the list of networks returned
    # @option query [OneviewSDK::ServerHardware] 'server_hardware' The server hardware associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    # @option query [String] 'view' Name of a predefined view to return a specific subset of the attributes of the resource or collection
    # @return [Hash{String=>Array<OneviewSDK::EthernetNetwork>,Array<OneviewSDK::FCNetwork>}]
    #   A hash containing the lists of Ethernet Networks and FC Networks
    #   Options:
    #     * [String] :ethernet_networks The list of Ethernet Networks
    #     * [String] :fc_networks The list of FC Networks
    def self.get_available_networks(client, query = nil)
      query_uri = build_query(query) if query
      response = client.rest_get("#{BASE_URI}/available-networks#{query_uri}")
      body = client.response_handler(response)
      ethernet_networks = body['ethernetNetworks'].select { |info| OneviewSDK::EthernetNetwork.find_by(name: info['name']).first }
      fc_networks = body['fcNetworks'].select { |info| OneviewSDK::FCNetwork.find_by(name: info['name']).first }
      return {
        'ethernet_networks' => ethernet_networks,
        'fc_networks' => fc_networks
      }
    end

    # Get Available Servers based on the query parameters
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [OneviewSDK::ServerProfile] 'server_profile' The server profile associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    # @return [Hash] Hash containing all the available server information
    def self.get_available_servers(client, query = nil)
      query_uri = build_query(query) if query
      # profileUri attribute is not following the standards in OneView
      query_uri.sub!('serverProfileUri', 'profileUri')
      response = client.rest_get("#{BASE_URI}/available-servers#{query_uri}")
      client.response_handler(response)
    end

    # Get Available Storage System based on the query parameters
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    # @option query [OneviewSDK::StorageSystem] 'storage_system' The Storage System the resources are associated with
    def self.get_available_storage_system(client, query = nil)
      # For storage_system the query requires the ID instead the URI
      if query && query['storage_system']
        query['storage_system'].retrieve! unless query['storage_system']['uri']
        query['storage_system_id'] = query['storage_system']['uri'].partition('/').last
        query.delete(storage_system)
      end
      query_uri = build_query(query) if query
      response = client.rest_get("#{BASE_URI}/available-storage-system#{query_uri}")
      client.response_handler(response)
    end


    # Get Available Storage Systems based on the query parameters
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    # @option query [Array<String>] 'filter' A general filter/query string to narrow the list of items returned. The default is no filter - all resources are returned.
    # @option query [Integer] 'start' The first item to return, using 0-based indexing. If not specified, the default is 0 - start with the first available item.
    # @option query [Integer] 'count' The sort order of the returned data set. By default, the sort order is based on create time, with the oldest entry first.
    # @option query [String] 'sort' The number of resources to return. A count of -1 requests all the items.
    def self.get_available_storage_systems(client, query = nil)
      query_uri = build_query(query) if query
      response = client.rest_get("#{BASE_URI}/available-storage-systems#{query_uri}")
      client.response_handler(response)
    end

    # Get Available Targets based on the query parameters
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [OneviewSDK::ServerProfile] 'server_profile' The server profile associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    def self.get_available_targets(client, query = nil)
      query_uri = build_query(query) if query
      response = client.rest_get("#{BASE_URI}/available-targets#{query_uri}")
      client.response_handler(response)
    end

    # Get all the available Ethernet and FC Networks
    # @param [OneviewSDK::Client] client Appliance client
    # @param [Hash<String,Object>] query Query parameters
    # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
    # @option query [OneviewSDK::ServerHardware] 'server_hardware' The server hardware associated with the resource
    # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
    def self.get_profile_ports(client, query = nil)
      query_uri = build_query(query) if query
      response = client.rest_get("#{BASE_URI}/profile-ports#{query_uri}")
      client.response_handler(response)
    end

    def get_compliance_preview
      ensure_client & ensure_uri
      response = @client.rest_get("#{self['uri']}/compliance-preview")
      @client.response_handler(response)
    end

    def get_messages
      ensure_client & ensure_uri
      response = @client.rest_get("#{self['uri']}/messages")
      @client.response_handler(response)
    end

    def get_transformation
      ensure_client & ensure_uri
      response = @client.rest_get("#{self['uri']}/messages")
      @client.response_handler(response)
    end

    def compliance
      ensure_client & ensure_uri
      patch_opt = {'op' => 'replace', 'path' => '/templateCompliance', 'value' => 'Compliant'}
      response = @client.rest_patch(self['uri'], patch_opt)
      @client.response_handler(response)
    end

    # Get available server hardware
    # @return [Array<OneviewSDK::ServerHardware>] Array of ServerHardware resources that matches this
    #   profile's server hardware type and enclosure group and who's state is 'NoProfileApplied'
    def available_hardware
      ensure_client
      fail 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
      fail 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
      params = {
        state: 'NoProfileApplied',
        serverHardwareTypeUri: @data['serverHardwareTypeUri'],
        serverGroupUri: @data['enclosureGroupUri']
      }
      OneviewSDK::ServerHardware.find_by(@client, params)
    rescue StandardError => e
      raise "Failed to get available hardware. Message: #{e.message}"
    end

  end
end
