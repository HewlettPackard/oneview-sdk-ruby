# Examples

Now you can run the example files to test functionality of individual resources.

To test-run these examples, please:
  1. `cd` into this examples directory, then copy the `_client.rb.example` file to a new file named `_client.rb`;
  2. Modify it by inserting your credentials or authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client.rb.example` file;
  3. There are specific examples for a given api[200, 300, 500] and your variant[C7000, Synergy], as well as shared examples that should work for different versions of api.
     The api version that is used is according to the api version assigned in the creation of the client.
     Performs the desired example specifying the variant and api version uncommenting the variants options in the `_client.rb.example` file.
     NOTE: This doesn't apply to API versions less than or equal to 200. Because there are no variants for these apis.

  4. Run `ruby <shared_samples>/<example_file>.rb`.

## Image Streamer

To run the examples for Image Streamer, please:
  1. `cd` into this examples directory, then copy the `_client_i3s.rb.example` file to a new file named `_client_i3s.rb`;
  2. Modify it by inserting your authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client_i3s.rb.example` file;
  3. Run `ruby image-streamer/api300/<example_file>.rb`
  
 ### Running Examples with Docker
If you'd rather run the examples in a Docker container, you can use the Dockerfile at the top level of this repo.
All you need is Docker and git (optional).

1. Clone this repo and cd into it:
   ```bash
   $ git clone https://github.com/HewlettPackard/oneview-sdk-ruby
   $ cd oneview-sdk-ruby
   ```

   Note: You can navigate to the repo url and download the repo as a zip file if you don't want to use git

2. `cd` into this examples directory, then copy the `_client.rb.example` file to a new file named `_client.rb`.

3. Modify it by inserting your credentials or authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client.rb.example` file;

4. Build the docker image: `$ docker build -t oneview-ruby .`

   Note: If you're behind a proxy, please edit the Dockerfile before building, uncommenting/adding the necessary ENV directives for your environment.

5. Now you can run any of the examples in this directory:
   ```bash
   # Replace "fc_network" with the name of the recipe you'd like to run.
   # Replace "pwd" with the path of the example file you'd like to run.
   $ docker run -it --rm \
     -v $(pwd)/:/root/oneview
     oneview-ruby ruby examples/shared_samples/fc_network.rb
   ```

### To run ImageStreamer examples in docker:

Follow step1 as mentioned above, folllowed by steps mentioned below.
1. `cd` into this examples directory, then copy the `_client_i3s.rb.example` file to a new file named `_client_i3s.rb`.

2. Modify it by inserting your authentication token, ssl_enabled flag, and anything else your environment requires. The options are commented in the `_client_i3s.rb.example` file.

3. Now you can run any of the imagestreamer examples in this directory:
   ```bash
   # (Replace "plan_script" with the name of the example you'd like to run)
   # (Replace "pwd" with the path of the example file you'd like to run)
   $ docker run -it --rm \
     -v $(pwd)/:/root/oneview
     oneview-ruby ruby examples/image-streamer/api300/plan_script.rb
   ```

That's it! If you'd like to modify an example, simply modify the file (on the host), then re-build the image and run it.

## Concurrent Execution

Some of the tasks that can be performed using this library take quite a bit of time; after all, we *are* dealing with physical infrastructure.
Although this library doesn't provide special options to run tasks concurrently, there are ways to do this natively with Ruby.
To see some examples of how this can be done, take a look at the [concurrent_execution.rb](concurrent_execution.rb) file.
