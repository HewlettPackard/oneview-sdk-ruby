module OneviewSDK
  # Resource for logical interconnect groups
  # Common Data Attributes:
  #   category
  #   created
  #   description
  #   eTag
  #   Uplink sets (default [])
  #   modified
  #   name (Required)
  #   state
  #   status
  #   enclosureType (Required)
  #   uri
  #   interconnectMapTemplate (Required)
  class LogicalInterconnectGroup < Resource
    BASE_URI = '/rest/logical-interconnect-groups'
    attr_reader :bay_count, :interconnect_provider

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
      @bay_count ||= 8
      @interconnect_provider = OneviewSDK::InterconnectType.new(@client, {})
      # Create all entries if empty
      interconnect_map_template_parse if @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] == []
    end

    def add_interconnect(bay, model)
      @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          if location['type'] == 'Bay' && location['relativeValue'] == bay
            entry['permittedInterconnectTypeUri'] = @interconnect_provider.model_link(model)
          end
        end
      end
    end

    def add_uplink_set(uplink_set)
      @data['uplinkSets'] << uplink_set.to_hash
    end

    private

    def interconnect_map_template_parse
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
