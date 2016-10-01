require 'aws-sdk'
require 'colorize'
require 'terminal-table'

class CneCf
  def initialize
    @cf = Aws::CloudFormation::Resource.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    @cf_client = Aws::CloudFormation::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def list_all_stacks
    output = []

    @cf.stacks.each do |stack|
      output << [
        "#{stack.stack_name}".to_s.colorize(:green),
        "#{stack.stack_status}".colorize(:green),
        "#{stack.last_updated_time}".colorize(:green)
      ]
    end

    table = Terminal::Table.new(
      :headings => [
        'Stack Name'.colorize(:blue),
        'Stack Status'.colorize(:blue),
        'Stack Last Updated'.colorize(:blue)
      ],
      :rows => output.sort_by! { |name| name[0] }
    )

    puts table
  end

  def scale(cf_name, desired, max)
    stack = Aws::CloudFormation::Stack.new(cf_name)
    parameters = stack.parameters

    parameters.each do |param|
      if param['parameter_key'] == 'ScaleDesiredCapacity'
        param['parameter_value'] = desired
      elsif param['parameter_key'] == 'ScaleMin'
        param['parameter_value'] = desired
      elsif param['parameter_key'] == 'ScaleMax'
        param['parameter_value'] = max
      end
    end

    @cf_client.update_stack(
      {
        stack_name: cf_name,
        use_previous_template: true,
        capabilities: ["CAPABILITY_IAM"],
        parameters: parameters
      }
    )
  end
end
