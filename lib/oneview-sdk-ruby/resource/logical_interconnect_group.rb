module OneviewSDK
  # Resource for logical interconnect groups
  # Common Data Attributes:
  #   category
  #   created
  #   description
  #   enclosureType (Required)
  #   eTag
  #   interconnectMapTemplate (Required)
  #   modified
  #   name (Required)
  #   state
  #   status
  #   uplinkSets (Required) (default = [])
  #   uri
  class LogicalInterconnectGroup < Resource
    BASE_URI = '/rest/logical-interconnect-groups'
    attr_reader :bay_count

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['enclosureType'] ||= 'C7000'
      @data['state'] ||= 'Active'
      @data['uplinkSets'] ||= []
      @data['type'] ||= 'logical-interconnect-groupV3'
      @data['interconnectMapTemplate'] ||= {}
      @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] ||= []

      # User friendly values:
      @bay_count = 8

      # Create all entries if empty
      parse_interconnect_map_template if @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] == []
    end

    # Add an interconnect
    # @param [Fixnum] bay Bay number
    # @param [String] type InterconnectType
    def add_interconnect(bay, type)
      @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          if location['type'] == 'Bay' && location['relativeValue'] == bay
            entry['permittedInterconnectTypeUri'] = OneviewSDK::InterconnectType.find_by(@client, name: type).first['uri']
          end
        end
      end
    rescue StandardError
      list = OneviewSDK::InterconnectType.get_all(@client).map { |t| t['name'] }
      raise "Interconnect type #{type} not found! Supported types: #{list}"
    end

    # Add an uplink set
    # @param [OneviewSDK::LIGUplinkSet] uplink_set
    def add_uplink_set(uplink_set)
      @data['uplinkSets'] << uplink_set.data
    end

    private

    def parse_interconnect_map_template
      1.upto(@bay_count) do |bay_number|
        entry = {
          'logicalDownlinkUri' => nil,
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => bay_number, 'type' => 'Bay' },
              { 'relativeValue' => 1, 'type' => 'Enclosure' }
            ]
          },
          'permittedInterconnectTypeUri' => nil
        }
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
      end
    end

  end
end
