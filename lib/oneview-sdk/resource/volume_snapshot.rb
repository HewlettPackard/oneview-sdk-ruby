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

module OneviewSDK
  # Volume snapshot resource implementation
  class VolumeSnapshot < Resource
    BASE_URI = nil

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'Snapshot'
    end

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    # Sets the volume
    # @param [OneviewSDK::Volume] volume Volume
    def set_volume(volume)
      volume.retrieve! unless volume['uri']
      @data['storageVolumeUri'] = volume['uri']
    end
  end
end
