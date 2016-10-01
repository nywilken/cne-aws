# cne-aws
CNE AWS command line utility

## Setup
These environment variables must be set in your terminal before usage:

`AWS_REGION` `AWS_ACCESS_KEY_ID` `AWS_SECRET_ACCESS_KEY`

## Building and installing the gem locally
Tested on ruby-2.0.0-p648

To build and install:
`gem build cne-aws.gemspec && gem install cne-aws-<version>.gem`

## Installing the gem via git repo
`gem install specific_install && gem specific_install -l https://github.com/jpcallanta/cne-aws`

## Usage

#### Lists instances based on appname and environment
`cne-ec2 instances [appname] [environment]`

#### Lists all security groups
`cne-ec2 security`

#### Lists security groups based on search param regex
`cne-ec2 security [search-string]`

#### Lists unhealthy instances
`cne-ec2 unhealthy`

#### Lists all ELBs
`cne-ec2 elbs`

#### Terminate an instance
`cne-ec2 terminate [instance-id]`

#### Reboot an instance
`cne-ec2 reboot [instance-id]`

#### Stop an instance
`cne-ec2 stop [instance-id]`

#### List all CloudFormation stacks
`cne-cf stacks`

#### Scale CloudFormation stack
`cne-cf scale [stack-name] [desired-instance-count] [max-instance-count]`
