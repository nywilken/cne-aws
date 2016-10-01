require 'aws-sdk'
require 'colorize'
require 'terminal-table'

class CneAws
  def initialize
    @ec2_client = Aws::EC2::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    @elb_client = Aws::ElasticLoadBalancing::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def list_instances(appname, env)
    output = []
    instance_count = 0
    response = @ec2_client.describe_instances(

      filters: [
        {
          name: 'tag:appname',
          values: [appname]
        },

        {
          name: 'tag:env',
          values: [env]
        }
      ]
    )

    if response.reservations.count == 0
      puts 'No instances found'.colorize(:red)
      exit 1
    end

    puts "Displaying #{appname} (#{env}) instances:".colorize(:red)

    response.reservations.each do |reserve|
      reserve.instances.each do |instance|
        output <<  [
          "#{instance.private_ip_address}".colorize(:green),
          "#{instance.instance_id}".colorize(:green),
          "#{instance.placement.availability_zone}".colorize(:green),
          "#{instance.launch_time}".colorize(:green)
        ]

        instance_count += 1
      end
    end

    table = Terminal::Table.new(
      :headings => [
        'IP'.colorize(:blue),
        'Instance ID'.colorize(:blue),
        'AZ'.colorize(:blue),
        'Creation Date'.colorize(:blue)
      ],
      :rows => output
    )

    puts table
    puts "#{instance_count} instances".colorize(:red)
    puts ''
  end

  def list_security_groups(name)
    output = []
    response = @ec2_client.describe_security_groups

    if name.empty?
      response.security_groups.each do |group|
        output << [
          "#{group.group_id}".colorize(:green),
          "#{group.group_name}".colorize(:green),
          "#{group.description}".colorize(:green)
        ]
      end

      table = Terminal::Table.new(
        :headings => [
          'Group ID'.colorize(:blue),
          'Group Name'.colorize(:blue),
          'Group Description'.colorize(:blue)
        ],
        :rows => output.sort_by! { |name| name[1] }
      )

      puts table
    else
      response.security_groups.each do |group|
        if group.group_name =~ /#{name}/
          output << [
            "#{group.group_id}".colorize(:green),
            "#{group.group_name}".colorize(:green),
            "#{group.description}".colorize(:green)
          ]
        end
      end

      if output.empty?
        puts 'No security groups found...'.colorize(:red)
        exit 1
      end

      table = Terminal::Table.new(
        :headings => [
          'Group ID'.colorize(:blue),
          'Group Name'.colorize(:blue),
          'Group Description'.colorize(:blue)
        ],
        :rows => output.sort_by! { |name| name[1] }
      )

      puts table
    end
  end

  def get_instance_info(instance_id)
    response = @ec2_client.describe_instances(
      instance_ids: [instance_id]
    )

    return response.reservations
  end

  def get_elb_names
    response = @elb_client.describe_load_balancers

    return response.load_balancer_descriptions
  end

  def list_unhealthy_hosts
    unhealthy = []

    get_elb_names.each do |elb|
      response = @elb_client.describe_instance_health(
        load_balancer_name: elb.load_balancer_name
      )

      response.instance_states.each do |instance|
        if instance.state.include?('OutOfService')
          puts elb.load_balancer_name.colorize(:red)

          get_instance_info(instance.instance_id).each do |info|
            unhealthy << [
              "#{info.instances.first.instance_id}".colorize(:red),
              "#{info.instances.first.private_ip_address}".colorize(:red),
              "#{instance.state}".colorize(:red)
            ]
          end

          table = Terminal::Table.new(
            :headings => [
              'Instance ID'.colorize(:blue),
              'IP'.colorize(:blue),
              'Instance State'.colorize(:blue)
            ],
            :rows => unhealthy
          )
          puts table
          puts ''
        end
      end
    end

    if unhealthy.empty?
      puts 'All systems go! All ELBs are healthy!'.colorize(:green)
    end
  end
end
