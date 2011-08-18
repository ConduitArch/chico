require 'bundler'
Bundler.require(:default, :test)
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'chico'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def load_icon_file(name)
  IO.read(File.join(File.dirname(__FILE__), 'res', "#{name}.ico"))
end

def load_res_file(name)
  IO.read(File.join(File.dirname(__FILE__), 'res', name))
end

RSpec.configure do |config|
  
end
