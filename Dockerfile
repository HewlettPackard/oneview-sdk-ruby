FROM ubuntu:18.04
MAINTAINER "Chebrolu Harika <bala-sai-harika.chebrolu@hpe.com>"
WORKDIR /root
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-upgrade && \
    apt-get install -y curl vim wget openssl bash ca-certificates git && \
    apt-get install -y ruby-dev && \
    apt-get install -y gcc make
RUN gem install oneview
ADD . oneview/
WORKDIR  /root/oneview
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/lists/* /tmp/* /root/cache/.

CMD ["/bin/bash"]
