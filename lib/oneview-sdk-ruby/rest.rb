module OneviewSDK
  module Rest
    def rest_api(host, type, path, options = {})
      puts "Making #{type} rest call to #{host}.\n  Path: '#{path}'.\n  Options: #{options}"
    end
  end
end
