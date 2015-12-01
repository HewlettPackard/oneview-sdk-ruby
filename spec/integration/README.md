# Integration Testing
:warning: **WARNING** :warning:

**This will communicate with and modify a real OneView appliance.**

**The tests do their best cleanup after themselves, but know what they do before running them!**

:warning: **WARNING** :warning:

## Setup
First, there's some setup you'll need to do. Do EITHER of the following:

1. **Use environment variables to specify config file locations:**
  
  1. Copy the [one_view_config.json.example](one_view_config.json.example) and
   [one_view_secrets.json.example](one_view_secrets.json.example) files to a secure location
   **outside** this repo. When you do so, drop the `.example` part of the filename.

  2. Then set the following environment variables with the paths to the files you just created:

   ```bash
   export ONEVIEWSDK_INTEGRATION_CONFIG='/path/to/one_view_config.json'
   export ONEVIEWSDK_INTEGRATION_SECRETS='/path/to/one_view_secrets.json'
   ```

2. **Use default config file locations**
  
  1. Copy the [one_view_config.json.example](one_view_config.json.example) and
   [one_view_secrets.json.example](one_view_secrets.json.example) files into the same directory (spec/integration) and drop the `.example` part of the filename on the new coppies. You should now have the following files:
     
   ```bash
   spec/integration/one_view_config.json
   spec/integration/one_view_secrets.json
   ```

## Running the tests
Run `$ rake spec:integration`
