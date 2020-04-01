FROM ruby:alpine
ENV USER root
RUN apk update 
RUN apk add curl vim wget openssl bash ca-certificates
# RUN \curl -L https://get.rvm.io | rvm_tar_command=tar bash -s stable
# RUN /bin/bash -l -c "rvm install 2.0"
# RUN /bin/bash -l -c "gem install bundler"
RUN gem install oneview-sdk
CMD ["/bin/bash"]
