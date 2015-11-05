module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   associatedLogicalInterconnectGroups
  #   category
  #   created
  #   description
  #   eTag
  #   enclosureCount
  #   enclosureTypeUri
  #   interconnectBayMappingCount (required)
  #   interconnectBayMappings (required)
  #   ipAddressingMode
  #   ipRangeUris (not used in C7000 enclosure)
  #   modified
  #   name
  #   portMappingCount
  #   portMappings
  #   powerMode
  #   stackingMode (required)
  #   state
  #   status
  #   type (required)
  #   uri
  class EnclosureGroup < Resource
    BASE_URI = '/rest/enclosure-groups'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'EnclosureGroupV200'
    end

    def validate_interconnectBayMappingCount(value)
      fail 'Interconnect Bay Mapping Count out of range 1..8' unless value.between?(1,8)
    end

    def validate_ipAddressingMode(value)
      fail 'Invalid ip AddressingMode' unless %w(DHCP External IpPool).include?(value)
    end

    def validate_portMappingCount(value)
      fail 'Port Mapping Count out of range 0..8' unless value.between?(0,8)
    end

    def validate_powerMode(value)
      fail 'Invalid powerMode' unless %w(RedundantPowerFeed RedundantPowerSupply).include?(value) || value.nil?
    end

    def validate_stackingMode(value)
      fail 'Invalid network type' unless %w(Enclosure MultiEnclosure None SwitchPairs).include?(value)
    end

    def validate_state(value)
      fail 'Invalid network type' unless %w(Pending Failed Normal).include?(value)
    end

    def validate_status(value)
      fail 'Invalid network type' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end
    
    def validate_type(value)
      fail 'Invalid type' unless value == 'EnclosureGroupV200'
    end

  end
end
