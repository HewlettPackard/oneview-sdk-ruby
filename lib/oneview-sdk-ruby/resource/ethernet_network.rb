
module OneviewSDK
  class EthernetNetwork < Resource
    attr_accessor \
      :vlanId,
      :purpose,
      :smartLink,
      :privateNetwork,
      :ethernetNetworkType,
      :type,
      :connectionTemplateUri

    def initialize(params, client = nil)
      params.each do |key, value|
        unless %w(create delete save update refresh).include?(key.to_s)
          instance_variable_set("@#{key}", value)
          self.class.send(:attr_accessor, key) # If we'd rather, we can just use a get(key) method for additional attributes.
        end
      end
      @client ||= client if client
    end

    # Tell OneView to create the resource using the current attribute data
    def create
      fail 'Please set client attribute before creating this resource' unless @client
      puts "creating EthernetNetwork '#{@name}'"
      @uri = "/networks/newNetworkIdFor#{@name}"
    end

    # Save current attribute data to OneView
    def save
      fail 'Please set client attribute before saving this resource' unless @client
      puts "updating EthernetNetwork '#{@name}' using uri: '#{@uri}'"
      update
    end

    # Set attribute data and save to OneView
    def update(attributes = {})
      fail 'Please set client attribute before updating this resource' unless @client
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      puts "updating EthernetNetwork '#{@name}' using uri: '#{@uri}'"
    end

    # Updates this object using the data that exists on OneView
    def refresh
      fail 'Please set client attribute before refreshing this resource' unless @client
      puts "refreshing EthernetNetwork '#{@name}' using uri: '#{@uri}'"
    end

    # Make delete rest call to OneView and return true if successful or false if failed
    def delete
      fail 'Please set client attribute before deleting this resource' unless @client
      puts "deleting EthernetNetwork '#{@name}' using uri: '#{@uri}'"
    end

  end
end
