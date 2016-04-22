require 'yaml'
require 'json'

module OneviewSDK
  # Configuration helper class to allow .yaml & .json files to be easily used to specify OneView Configuration
  class Config

    # Load config from .yaml or .json file
    # @param [String] path The full path to the configuration file
    # @return [Hash] hash of the configuration
    def self.load(path)
      path = File.join(Dir.pwd, path) unless Pathname.new(path).absolute?
      expanded_path = File.expand_path(path)
      JSON.parse(IO.read(expanded_path))
    rescue
      data = YAML.load_file(expanded_path)
      Hash[data.map { |k, v| [k.to_s, v] }]
    end
  end
end
