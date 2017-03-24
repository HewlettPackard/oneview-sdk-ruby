# Integration Testing
:warning: **WARNING**

**The integration tests are going to communicate with and modify a real OneView appliance.**

**The tests do their best cleanup after themselves, but know what they do before running them!**

## Setup
First, there's some setup you'll need to do. Do **EITHER** of the following:

### Option 1: Use default config file locations

  Copy the [one_view_config.json.example](one_view_config.json.example),
   [one_view_secrets.json.example](one_view_secrets.json.example), [one_view_synergy_config.json.example](one_view_synergy_config.json.example) and
   [one_view_synergy_secrets.json.example](one_view_synergy_secrets.json.example) files into the same directory (spec/integration) and drop the `.example` part of the filename on the new copies. You should now have the following files:

```bash
spec/integration/one_view_config.json # Tests for API v200 and API v300 C7000
spec/integration/one_view_secrets.json # Tests for API v200 and API v300 C7000
spec/integration/one_view_synergy_config.json # Tests for API v300 Synergy
spec/integration/one_view_synergy_secrets.json # Tests for API v300 Synergy
```

### Option 2: Use environment variables to specify config file locations:**

1. Copy the [one_view_config.json.example](one_view_config.json.example),
   [one_view_secrets.json.example](one_view_secrets.json.example), [one_view_synergy_config.json.example](one_view_synergy_config.json.example) and
   [one_view_synergy_secrets.json.example](one_view_synergy_secrets.json.example) files to a secure location
   **outside** this repo. When you do so, drop the `.example` part of the filename.

   - [one_view_config.json.example](one_view_config.json.example): Tests for API v200 and API v300 C7000
   - [one_view_secrets.json.example](one_view_secrets.json.example): Tests for API v200 and API v300 C7000
   - [one_view_config.json.example](one_view_config.json.example): Tests for API v300 Synergy
   - [one_view_secrets.json.example](one_view_secrets.json.example): Tests for API v300 Synergy

2. Then set the following environment variables with the paths to the files you just created:

   ```bash
   export ONEVIEWSDK_INTEGRATION_CONFIG='/path/to/one_view_config.json'
   export ONEVIEWSDK_INTEGRATION_SECRETS='/path/to/one_view_secrets.json'
   export ONEVIEWSDK_INTEGRATION_CONFIG_SYNERGY='/path/to/one_view_synergy_config.json'
   export ONEVIEWSDK_INTEGRATION_SECRETS_SYNERGY='/path/to/one_view_synergy_secrets.json'
   ```



These config files get loaded and create the following global variables:
 - `$secrets`: Credentials for connecting to new resources
 - `$config`: Config for connecting to OneView appliance
 - `$client_120`: Client object pinned to API v120
 - `$client`: Client object pinned to API v200
 - `$client_300`: Client object pinned to API v300 C7000
 - `$client_300_synergy`: Client object pinned to API v300 Synergy


## Setup for Image Streamer
First, there's some setup you'll need to do. Do **EITHER** of the following:

### Option 1: Use default config file locations

  Copy the [one_view_synergy_config.json.example](one_view_synergy_config.json.example) and [i3s_config.json.example](i3s_config.json.example)
   files into the same directory (spec/integration) and drop the `.example` part of the filename on the new copies.
   You should now have the following files:

```bash
spec/integration/one_view_synergy_config.json
spec/integration/i3s_config.json # Tests for API v300 Image Streamer
```

### Option 2: Use environment variables to specify config file locations:**

1. Copy the [one_view_synergy_config.json.example](one_view_synergy_config.json.example) and [i3s_config.json.example](i3s_config.json.example)
    files to a secure location **outside** this repo. When you do so, drop the `.example` part of the filename.

   - [one_view_synergy_config.json.example](one_view_synergy_config.json.example):
   - [i3s_config.json.example](i3s_config.json.example): Tests for API v300 Image Streamer

2. Then set the following environment variables with the paths to the files you just created:

   ```bash
   export ONEVIEWSDK_INTEGRATION_CONFIG_SYNERGY='/path/to/one_view_synergy_config.json'
   export I3S_INTEGRATION_CONFIG='/path/to/i3s_config.json'
   ```



These config files get loaded and create the global variables `$client_i3s_300`.

## Running the tests
The following command must run in your Ruby SDK root directory:

Run `$ rake -T` to show all the available rake tasks.

Then run any number of integration tests:

```ruby
$ rake spec:integration
$ rake spec:integration:create
$ rake spec:integration:update
$ rake spec:integration:delete
$ rake spec:integration:api_version[ver]        # eg, spec:integration:api_version[300]
$ rake spec:integration:api[version,model]      # eg, spec:integration:api_version[300,c7000]
$ rake spec:integration:delete:api_version[ver] # eg, spec:integration:delete:api_version[300]
$ rake test:path[path]        # eg, test:path['spec/integration/resource/api200/connection_template']

# Tests for Image Streamer
$ rake spec:integration:i3s
$ rake spec:integration:i3s:create
$ rake spec:integration:i3s:update
$ rake spec:integration:i3s:delete
$ rake spec:integration:i3s:api_version[ver]        # eg, spec:integration:i3s:api_version[300]
$ rake test:i3s:path[path]        # eg, test:i3s:path['spec/integration/image-streamer/api300/os_volume']
```
