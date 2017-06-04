require 'minitest/autorun'
require '../lib/cne_ec2'

class CneEc2Test < Minitest::Test
  def test_initailize_with_no_credentials
    assert_raises(StandardError, CneEc2.new)
  end
end
