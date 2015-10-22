module OneviewSDK
  # Contains all the methods for making API REST calls
  module Rest
    def rest_api(type, path, options = {}, api_version = @default_api_version)
      puts "Making :#{type} rest call to #{@url}#{path}\n  API Version: #{api_version}\n  Options: #{options}"
    end

    def rest_get(path, api_version = @default_api_version)
      rest_api(:get, path, {}, api_version)
    end

    def rest_post(path, options = {}, api_version = @default_api_version)
      rest_api(:post, path, options, api_version)
    end

    def rest_put(path, options = {}, api_version = @default_api_version)
      rest_api(:put, path, options, api_version)
    end

    def rest_delete(path, api_version = @default_api_version)
      rest_api(:delete, path, {}, api_version)
    end
  end
end
