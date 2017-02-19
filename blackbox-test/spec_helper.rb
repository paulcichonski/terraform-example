require 'turnip/rspec'
require 'turnip_formatter'
require 'rspec_junit_formatter'
require 'rspec/instafail'

RSpec.configure do |config|
  # configure formatters
  config.add_formatter 'documentation'
  config.color = true
  config.add_formatter RSpecTurnipFormatter, "/opt/project/test-reports/servicetest-report.html"
  config.add_formatter RspecJunitFormatter, "/opt/project/test-reports/servicetest-rspec-junit.xml"
  config.add_formatter RSpec::Instafail

  # fail when steps are unimplemented
  config.raise_error_for_unimplemented_steps = true

  # load base helpers
  Dir.glob("blackbox-test/helpers/**/*_helper.rb") { |f| load f }
  config.include EventuallyHelper, :type => :feature
  Dir.glob("blackbox-test/steps/**/*_steps.rb") { |f| load f }

  config.before(:suite) do
    puts "== Building Infrastructure"
    TerraformHelper.apply
  end

  config.after(:suite) do
    ## in a non-toy example we would normally not destroy the infra if the tests failed.

    puts "== Destroying Infrastructure"
    TerraformHelper.destroy
  end
end
