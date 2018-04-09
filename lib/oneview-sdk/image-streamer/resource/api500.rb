# (c) Copyright 2018 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../resource'

module OneviewSDK
  # Module Image Streamer
  module ImageStreamer
    # Module API 500
    module API500
      # Get resource class that matches the type given
      # @param [String] type Name of the desired class type
      # @param [String] variant There is only 1 variant for this module, so this is not used.
      #   It exists only so that the parameters match API modules that do have multiple variants.
      # @return [Class] Resource class or nil if not found
      def self.resource_named(type, _variant = nil)
        new_type = type.to_s.downcase.gsub(/[ -_]/, '')
        constants.each do |c|
          klass = const_get(c)
          next unless klass.is_a?(Class) && klass < OneviewSDK::Resource
          name = klass.name.split('::').last.downcase.delete('_').delete('-')
          return klass if new_type =~ /^#{name}[s]?$/
        end
        nil
      end
    end
  end
end

# Load all API-specific resources:
Dir[File.dirname(__FILE__) + '/api500/*.rb'].each { |file| require file }
