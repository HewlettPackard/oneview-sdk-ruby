require 'yaml'

module OneviewSDK
  # Configuration helper class to allow yaml files to be easily used to specify OneView Configuration
  class Config

    # Load config from YAML file
    def self.load(path)
      config = YAML.load_file(File.expand_path(path))
    end
  end
end
