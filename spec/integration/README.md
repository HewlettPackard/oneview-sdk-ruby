# Integration Testing
:warning: **WARNING** :warning:

**This will communicate with and modify a real OneView appliance.**

**The tests do their best cleanup after themselves, but know what they do before running them!**

:warning: **WARNING** :warning:

### Setup
First, there's some setup you'll need to do:

1. Copy the [one_view_config.json.example](one_view_config.json.example) and 
   [one_view_secrets.json.example](one_view_secrets.json.example) files to a secure location
   **outside** this repo. When you do so, drop the `.example` part of the filename.
2. Blah
3. Set the following environment variables with the paths to the files you just created:
   
   ```bash
   export ONEVIEWSDK_INTEGRATION_CONFIG='/path/to/one_view_config.json'
   export ONEVIEWSDK_INTEGRATION_SECRETS='/path/to/one_view_secrets.json'
   ```

### Running the tests
Run `$ rake spec:integration`
