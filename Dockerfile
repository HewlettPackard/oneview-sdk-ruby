FROM ubuntu:18.04
MAINTAINER "Chebrolu Harika <bala-sai-harika.chebrolu@hpe.com>"
WORKDIR /root
RUN apt-get update && \ 
    apt-get install -y curl vim wget openssl bash ca-certificates git && \
    apt-get install -y ruby-dev && \
    apt-get install -y gcc make
RUN gem install oneview && \
    git clone https://github.com/HewlettPackard/oneview-sdk-ruby.git oneview-ruby
WORKDIR  /root/oneview-ruby
RUN gem install bundler
RUN bundle install
CMD ["/bin/bash"]
