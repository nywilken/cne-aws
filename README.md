# cne-aws
CNE AWS command line utility

## Setup
These environment variables must be set in your terminal before usage:

`AWS_REGION` `AWS_ACCESS_KEY_ID` `AWS_SECRET_ACCESS_KEY`

## Building and installing the gem locally
Tested on ruby-2.1.2

To build and install:
`gem build cne-aws.gemspec && gem install cne-aws-<version>.gem`

## Building and installing the gem via repo
`gem install specific_install && gem specific_install -l https://github.com/jpcallanta/cne-aws`

## Usage

#### Lists instances based on tag
`cne instances [appname_tag_val] [env_tag_val]`

#### Lists all security groups
`cne security`

#### Lists security groups based on search param regex
`cne security [search param]`
