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
    # @return [Hash{String=>Array<OneviewSDK::EthernetNetwork>,Array<OneviewSDK::FCNetwork>}] 
    #   A hash containing the lists of Ethernet Networks and FC Networks
    # @option bununu [String] :ethernet_networks The list of Ethernet Networks
    # @option bununu [String] :fc_networks The list of FC Networks
    def self.get_available_networks(client)
      response = client.rest_get("#{BASE_URI}/available-networks")
      ethernet_networks = response.body['ethernetNetworks'].select { |info| OneviewSDK::EthernetNetwork.find_by(name: info['name']).first }
      fc_networks = response.body['fcNetworks'].select { |info| OneviewSDK::FCNetwork.find_by(name: info['name']).first }
      return {
        'ethernet_networks' => ethernet_networks,
        'fc_networks' => fc_networks
      }
    end

    def self.get_available_servers
    end

    def self.get_available_storage_system
    end

    def self.get_available_storage_systems
    end

    def self.get_available_targets
    end

    def self.get_profile_ports
    end

    def get_compliance_preview
    end

    def get_messages
    end

    def get_transformation
    end

    def compliance
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
