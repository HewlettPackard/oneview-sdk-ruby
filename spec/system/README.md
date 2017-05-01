# System Testing
:warning: **WARNING**

**The system tests are going to communicate with and modify a real OneView appliance.**

**The tests do their best cleanup after themselves, but know what they do before running them!**

## Setup
First, there's some setup you'll need to do. Do EITHER of the following:

1. **Use environment variables to specify config file locations:**

  1. Copy the [one_view_config.json.example](one_view_config.json.example), [one_view_secrets.json.example](one_view_secrets.json.example),
   [one_view_config_synergy.json.example](one_view_config_synergy.json.example),
   [one_view_secrets_synergy.json.example](one_view_secrets_synergy.json.example) files to a secure location
   **outside** this repo. When you do so, drop the `.example` part of the filename.

   - [one_view_config.json.example](one_view_config.json.example): Tests for API v200 and API v300 C7000
   - [one_view_secrets.json.example](one_view_secrets.json.example): Tests for API v200 and API v300 C7000
   - [one_view_config_synergy.json.example](one_view_config_synergy.json.example): Tests for API v300 Synergy
   - [one_view_secrets_synergy.json.example](one_view_secrets_synergy.json.example): Tests for API v300 Synergy

  2. Then set the following environment variables with the paths to the files you just created:

   ```bash
   export ONEVIEWSDK_SYSTEM_CONFIG='/path/to/one_view_config.json'
   export ONEVIEWSDK_SYSTEM_SECRETS='/path/to/one_view_secrets.json'
   export ONEVIEWSDK_SYSTEM_CONFIG_SYNERGY='/path/to/one_view_config_synergy.json'
   export ONEVIEWSDK_SYSTEM_SECRETS_SYNERGY='/path/to/one_view_secrets_synergy.json'
   ```

2. **Use default config file locations**

  1. Copy the [one_view_config.json.example](one_view_config.json.example), [one_view_secrets.json.example](one_view_secrets.json.example),
   [one_view_config_synergy.json.example](one_view_config_synergy.json.example),
   [one_view_secrets_synergy.json.example](one_view_secrets_synergy.json.example) files into the same directory (spec/integration)
   and drop the `.example` part of the filename on the new coppies. You should now have the following files:

   ```bash
   spec/system/one_view_config.json
   spec/system/one_view_secrets.json
   spec/system/one_view_config_synergy.json
   spec/system/one_view_secrets_synergy.json
   ```

These config files get loaded and create the following global variables:
 - `$secrets`:
 - `$config`: Config for connecting to OneView appliance
 - `$client_120`: Client object pinned to API v120
 - `$client`: Client object pinned to API v200
 - `$client_300`: Client object using API v300 C7000
 - `$client_300_synergy`: Client object using API v300 Synergy

## Running the tests
The following command must run in your Ruby SDK root directory:

Run `$ rake -T` to show all the available rake tasks.

Then run any number of system tests:

```ruby
$ rake system
$ rake system:path[path]                    # e.g. system:path[spec/system/light*/api200]
$ rake system:only[api_ver,variant,profile] # e.g. system:only[300,synergy,light]
$ rake system:only[api_ver]                 # e.g. system:only[300]
$ rake system:only[,variant]                # e.g. system:only[,synergy]
$ rake system:only[,,profile]               # e.g. system:only[,,light]
```

Note: Set the `PRINT_METADATA_ONLY` environment variable (to anything) to print the order of the tests only (without actually running any tests)
