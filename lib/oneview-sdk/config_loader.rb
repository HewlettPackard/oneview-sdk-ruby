# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'yaml'
require 'json'

module OneviewSDK
  # Configuration helper class to allow .yaml and .json files to be easily used to specify OneView Configuration
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
      JSON.parse(data.to_json) # Convert to and from JSON to ensure compatibility
    end
  end
end
