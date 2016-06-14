module OneviewSDK
  # Datacenter resource implementation
  class Datacenter < Resource
    BASE_URI = '/rest/datacenters'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['contents'] ||= []
    end

    # @!group Validates

    def validate_width(value)
      fail 'Invalid width, value must be between 1000 and 50000' unless value.between?(1000, 50_000)
    end

    def validate_depth(value)
      fail 'Invalid depth, value must be between 1000 and 50000' unless value.between?(1000, 50_000)
    end

    # @!endgroup

    # Adds existing rack to datacenter
    # @param [OneviewSDK::Rack] rack rack
    # @param [Decimal] pos_x x position
    # @param [Decimal] pos_y y position
    # @param [Decimal] rotation Rotation degrees (0-359) around the center of the resource
    def add_rack(rack, pos_x, pos_y, rotation = 0)
      @data['contents'] << {
        'resourceUri' => rack['uri'],
        'x' => pos_x,
        'y' => pos_y,
        'rotation' => rotation
      }
    end

    # Removes a rack from the datacenter
    # @param [OneviewSDK::Rack] rack rack
    def remove_rack(rack)
      @data['contents'].reject! { |resource| resource['resourceUri'] == rack['uri'] }
    end

    # Get a list of visual content objects
    # @return [Hash]
    def get_visual_content
      response = @client.rest_get(@data['uri'] + '/visualContent')
      @client.response_handler(response)
    end

  end
end
