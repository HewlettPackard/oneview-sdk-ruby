module OneviewSDK
  # Enclosure group resource implementation
  class EnclosureGroup < Resource
    BASE_URI = '/rest/enclosure-groups'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'EnclosureGroupV200'
      @data['interconnectBayMappingCount'] ||= 8
      create_interconnect_bay_mapping unless @data['interconnectBayMappings']
    end

    # @!group Validates

    VALID_INTERCONNECT_BAY_MAPPING_COUNTS = (1..8).freeze
    def validate_interconnectBayMappingCount(value)
      fail 'Interconnect Bay Mapping Count out of range 1..8' unless VALID_INTERCONNECT_BAY_MAPPING_COUNTS.include?(value)
    end

    VALID_IP_ADDRESSING_MODES = %w(DHCP External IpPool).freeze
    def validate_ipAddressingMode(value)
      return if !@data['enclosureTypeUri'] || /c7000/ =~ @data['enclosureTypeUri']
      is_not_a_c7000_without_ip_addressing_mode = !(/c7000/ =~ @data['enclosureTypeUri']) && !value
      fail "Invalid ip AddressingMode: #{value}" if !VALID_IP_ADDRESSING_MODES.include?(value) || is_not_a_c7000_without_ip_addressing_mode
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

    # @!endgroup

    # Get the script executed by enclosures in this enclosure group
    # @return [String] script for this enclosure group
    def get_script
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

    # Add logical interconnect group
    # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
    def add_logical_interconnect_group(lig)
      lig.retrieve! unless lig['uri']
      lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          add_lig_to_bay(location['relativeValue'], lig) if location['type'] == 'Bay' && entry['permittedInterconnectTypeUri']
        end
      end
    end

    # Create interconnect bay mapping
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

    private

    # Add logical interconnect group to bay
    # @param [Integer] bay Bay number
    # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
    def add_lig_to_bay(bay, lig)
      @data['interconnectBayMappings'].each do |location|
        return location['logicalInterconnectGroupUri'] = lig['uri'] if location['interconnectBay'] == bay
      end
    end

  end
end
