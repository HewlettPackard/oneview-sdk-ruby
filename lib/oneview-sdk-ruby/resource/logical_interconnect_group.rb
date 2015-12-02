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
      @data['enclosureType'] = "C7000"
      @data['state'] = "Active"
      @data['uplinkSets'] = []
      @data['type'] = "logical-interconnect-groupV3"
      @data['interconnectMapTemplate'] = {}
      # User friendly values:
      @data['interconnectBayMap'] = {}
      @bay_count = 8
      @interconnect_provider = OneviewSDK::InterconnectType.new(@client, {})
    end

    def add_interconnect(bay, model)
      @data['interconnectBayMap'].store(bay, @interconnect_provider.model_link(model))
    end

    def add_uplink_set(uplink_set)
      @data['uplinkSets'] << uplink_set.to_hash
    end

    def create
      interconnect_map_template_parse
      @data.delete('interconnectBayMap')
      super
    end

    # # Validate X
    # # @param [X] value X..Y
    # def validate_X(value)
    #   fail 'X out of range X..Y' unless value.between?(X, Y)
    # end

    private

    def interconnect_map_template_parse
      if @data['interconnectMapTemplate'] == {}
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] = []
        1.upto(@bay_count) do |bay_number|
          entry = {
            "logicalDownlinkUri" => nil,
            "logicalLocation" => {
              "locationEntries" => [
                {"relativeValue" => bay_number, "type" => "Bay" },
                {"relativeValue" => 1, "type" => "Enclosure" }
              ]
            },
            "permittedInterconnectTypeUri" => @data["interconnectBayMap"][bay_number]
          }
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
        end
      end
    end

  end
end
