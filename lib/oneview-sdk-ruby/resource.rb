module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    attr_accessor \
      :client,
      :name,
      :uri,
      :api_version

    def initialize(params, client = nil, api_ver = OneviewSDK::Client::DEFAULT_API_VERSION)
      params.each do |key, value|
        unless %w(create delete save update refresh).include?(key.to_s)
          instance_variable_set("@#{key}", value)
          self.class.send(:attr_accessor, key) # If we'd rather, we can just use a get(key) method for additional attributes.
        end
      end
      @client ||= client if client
      @api_version ||= api_ver
    end

    def to_hash
      ret_val = {}
      instance_variables.each do |key|
        ret_val["#{key[1..-1]}"] = instance_variable_get(key) unless key == :@client
      end
      ret_val
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    def []=(key, value)
      instance_variable_set("@#{key}", value)
    end

    def ==(other)
      self_state  = instance_variables.sort.map { |v| instance_variable_get(v) }
      other_state = other.instance_variables.sort.map { |v| other.instance_variable_get(v) }
      other.class == self.class && other_state == self_state
    end

    def eql?(other)
      self == other
    end

    # Tell OneView to create the resource using the current attribute data
    def create
      ensure_client
      @client.rest_post(self.class::CREATE_URI, to_hash, @api_version)
    end

    # Save current attribute data to OneView
    def save
      ensure_client
      @client.rest_put(@uri, to_hash, @api_version)
    end

    # Set attribute data and save to OneView
    def update(attributes = {})
      ensure_client
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      save
    end

    # Updates this object using the data that exists on OneView
    def refresh
      ensure_client
      @client.rest_get(@uri, @api_version)
    end

    # Make delete rest call to OneView and return true if successful or false if failed
    def delete
      ensure_client
      @client.rest_delete(@uri, @api_version)
    end

    private

    # Fail unless @client is set for this resource.
    def ensure_client
      fail 'Please set client attribute before interacting with this resource' unless @client
    end
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
