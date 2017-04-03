# Examples

Now you can run the example files to test functionality of individual resources.

To test-run these examples, please:
  1. `cd` into this examples directory, then copy the `_client.rb.example` file to a new file named `_client.rb`;
  2. Modify it by inserting your credentials or authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client.rb.example` file;
  3. There are specific examples for a given api[200, 300] and your variant[C7000, Synergy], as well as shared examples that should work for different versions of api.
     The api version that is used is according to the api version assigned in the creation of the client.
     Performs the desired example specifying the variant.
     Run `ruby <shared_samples>/<example_file>.rb` for API 200.
     Run `ruby <shared_samples>/<example_file>.rb C7000` for API greater than 200 and C7000 variant.
     Run `ruby <shared_samples>/<example_file>.rb Synergy` for API greater than 200 and Synergy variant.

## Image Streamer

To run the examples for Image Streamer, please:
  1. `cd` into this examples directory, then copy the `_client_i3s.rb.example` file to a new file named `_client_i3s.rb`;
  2. Modify it by inserting your authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client_i3s.rb.example` file;
  3. Run `ruby image-streamer/api300/<example_file>.rb`

## Concurrent Execution

Some of the tasks that can be performed using this library take quite a bit of time; after all, we *are* dealing with physical infrastructure.
Although this library doesn't provide special options to run tasks concurrently, there are ways to do this natively with Ruby.
To see some examples of how this can be done, take a look at the [concurrent_execution.rb](concurrent_execution.rb) file.
