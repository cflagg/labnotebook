FROM ubuntu:14.04

## pass appropriate environmental variables to build successfully.  Including environments.  

## Configure ruby environment
RUN apt-get -qq update && apt-get -qy upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ruby1.9.1 ruby1.9.1-dev make bundler libxml2-dev libxslt1-dev libcurl4-openssl-dev git pandoc pandoc-citeproc
RUN gem install nokogiri -v '1.6.3.1'

## An ADD invalidates cache.  use RUN instead:
RUN git clone https://github.com/cboettig/labnotebook.git
WORKDIR /labnotebook
RUN bundle config build.nokogiri --use-system-libraries && bundle install && bundle update

## Build site
# RUN bundle exec rake site:build


## Build environment for compiling Bootstrap >= 3.0.0 (Node.js / SASS environment)
RUN apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository ppa:chris-lea/node.js && apt-get -qq update && apt-get -qy install python-software-properties python g++ make nodejs 
# RUN apt-get --purge remove node
RUN npm install -g grunt-cli
WORKDIR /labnotebook/assets/_bootstrap-3.1.1
RUN npm install
RUN make


WORKDIR /labnotebook
## CMD bundle exec site deploy