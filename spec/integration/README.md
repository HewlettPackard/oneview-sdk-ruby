# Integration Testing
:warning: **WARNING**

**The integration tests are going to communicate with and modify a real OneView appliance.**

**The tests do their best cleanup after themselves, but know what they do before running them!**

## Setup
First, there's some setup you'll need to do. Do **EITHER** of the following:

### Option 1: Use default config file locations

  Copy the [one_view_config.json.example](one_view_config.json.example) and
   [one_view_secrets.json.example](one_view_secrets.json.example) files into the same directory (spec/integration) and drop the `.example` part of the filename on the new coppies. You should now have the following files:

```bash
spec/integration/one_view_config.json
spec/integration/one_view_secrets.json
spec/integration/one_view_synergy_config.json
spec/integration/one_view_synergy_secrets.json
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

## Running the tests
The following command must run in your Ruby SDK root directory:

Run `$ rake -T` to show all the available rake tasks.

Then run any number of integration tests:

```ruby
$ rake spec:integration
$ rake spec:integration:create
$ rake spec:integration:update
$ rake spec:integration:delete
$ rake spec:integration:api_version[version]        # eg, spec:integration:api_version[300]
$ rake spec:integration:api[version,model]          # eg, spec:integration:api_version[300,c7000]
$ rake spec:integration:delete:api_version[version] # eg, spec:integration:delete:api_version[300]
```
