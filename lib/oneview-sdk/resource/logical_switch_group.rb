module OneviewSDK
  # Logical Switch Group resource implementation
  class LogicalSwitchGroup < Resource
    BASE_URI = '/rest/logical-switch-groups'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['category'] ||= 'logical-switch-groups'
      @data['state'] ||= 'Active'
      @data['type'] ||= 'logical-switch-group'
      @data['switchMapTemplate'] ||= {}
    end

    # Define how the switches willl be grouped setting the number and the type of the switches
    # @param [Fixnum] number_of_switches Number of the switch inside the group [1,2]
    # @param [String] type Switch type name
    def set_grouping_parameters(number_of_switches, type)
      @data['switchMapTemplate']['switchMapEntryTemplates'] = []
      parse_switch_map_template(number_of_switches)
      switch_type_uri = OneviewSDK::Switch.get_type(@client, type)['uri']
      @data['switchMapTemplate']['switchMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          entry['permittedSwitchTypeUri'] = switch_type_uri if location['type'] == 'StackingMemberId'
        end
      end
    rescue StandardError
      list = OneviewSDK::Switch.get_types(@client).map { |t| t['name'] }
      raise "Switch type #{type} not found! Supported types: #{list}"
    end

    private

    def parse_switch_map_template(number_of_switches)
      1.upto(number_of_switches) do |stacking_member_id|
        entry = {
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => stacking_member_id, 'type' => 'StackingMemberId' },
            ]
          },
          'permittedSwitchTypeUri' => nil
        }
        @data['switchMapTemplate']['switchMapEntryTemplates'] << entry
      end
    end

  end
end
