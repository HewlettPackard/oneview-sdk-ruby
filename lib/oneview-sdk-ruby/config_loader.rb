require 'yaml'
require 'json'

module OneviewSDK
  # Configuration helper class to allow .yaml & .json files to be easily used to specify OneView Configuration
  class Config

    # Load config from .yaml or .json file
    # @param [String] path the full path to the configuration file
    # @return [Hash] hash of the configuration
    def self.load(path)
      expanded_path = File.expand_path(path)
      if File.extname(expanded_path) == '.json'
        return JSON.parse(IO.read(expanded_path))
      else
        return YAML.load_file(expanded_path)
      end
    end
  end
end
