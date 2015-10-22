module OneviewSDK
  class Resource
    DEFAULT_API_VERSION = 200

    attr_accessor \
      :client,
      :name,
      :uri,
      :api_version

    def to_hash
      ret_val = {}
      instance_variables.each do |key|
        ret_val["#{key[1..-1]}"] = instance_variable_get(key) unless key == :@client
      end
      ret_val
    end

    # May want to add create, delete, and update methods here too if the rest calls are similar across the board.
    # These will probably just use a simple rest call to @uri with the correct rest method
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
