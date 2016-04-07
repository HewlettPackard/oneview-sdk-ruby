module OneviewSDK
  # Resource for enclosure groups
  # Common Data Attributes:
  #   associatedLogicalInterconnectGroups
  #   category
  #   created
  #   description
  #   eTag
  #   enclosureCount
  #   enclosureTypeUri
  #   interconnectBayMappingCount (Required)
  #   interconnectBayMappings (Required)
  #   ipAddressingMode
  #   ipRangeUris (not used in C7000 enclosure)
  #   modified
  #   name
  #   portMappingCount
  #   portMappings
  #   powerMode
  #   stackingMode (Required)
  #   state
  #   status
  #   type (Required)
  #   uri
  class EnclosureGroup < Resource
    BASE_URI = '/rest/enclosure-groups'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      case @api_version
      when 120
        @data['type'] ||= 'EnclosureGroupV2'
      when 200
        @data['type'] ||= 'EnclosureGroupV200'
      end
      @data['interconnectBayMappingCount'] ||= 8
      create_interconnect_bay_mapping unless @data['interconnectBayMappings']
    end

    # Get the script executed by enclosures in this enclosure group
    # @return [String] script for this enclosure group
    def script
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/script', @api_version)
      @client.response_handler(response)
    end

    # Change the script executed by enclosures in this enclosure group
    # @param [String] body script to be executed
    # @return true if set successfully
    def set_script(body)
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/script', { 'body' => body }, @api_version)
      @client.response_handler(response)
      true
    end

    def add_logical_interconnect_group(lig)
      lig.retrieve! unless lig['uri']
      lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          add_lig_to_bay(location['relativeValue'], lig['uri']) if location['type'] == 'Bay'
        end
      end
    end

    def add_lig_to_bay(bay, url)
      @data['interconnectBayMappings'].each do |location|
        return location['logicalInterconnectGroupUri'] = url if location['interconnectBay'] == bay
      end
    end

    def create_interconnect_bay_mapping
      @data['interconnectBayMappings'] = []
      1.upto(@data['interconnectBayMappingCount']) do |bay_number|
        entry = {
          'interconnectBay' => bay_number,
          'logicalInterconnectGroupUri' => nil
        }
        @data['interconnectBayMappings'] << entry
      end
    end

    VALID_INTERCONNECT_BAY_MAPPING_COUNTS = (1..8).freeze
    def validate_interconnectBayMappingCount(value)
      fail 'Interconnect Bay Mapping Count out of range 1..8' unless VALID_INTERCONNECT_BAY_MAPPING_COUNTS.include?(value)
    end

    VALID_IP_ADDRESSING_MODES = %w(DHCP External IpPool).freeze
    def validate_ipAddressingMode(value)
      fail 'Invalid ip AddressingMode' unless VALID_IP_ADDRESSING_MODES.include?(value)
    end

    VALID_PORT_MAPPING_COUNTS = (0..8).freeze
    def validate_portMappingCount(value)
      fail 'Port Mapping Count out of range 0..8' unless VALID_PORT_MAPPING_COUNTS.include?(value)
    end

    VALID_POWER_MODES = ['RedundantPowerFeed', 'RedundantPowerSupply', nil].freeze
    def validate_powerMode(value)
      fail 'Invalid powerMode' unless VALID_POWER_MODES.include?(value)
    end

    VALID_STACKING_MODES = %w(Enclosure MultiEnclosure None SwitchPairs).freeze
    def validate_stackingMode(value)
      fail 'Invalid stackingMode' unless VALID_STACKING_MODES.include?(value)
    end

  end
end
