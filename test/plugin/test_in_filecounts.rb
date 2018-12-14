require "helper"
require "fluent/plugin/in_filecounts.rb"

class FilecountInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::FilecountsInput).configure(conf)
  end
end
