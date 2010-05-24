$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rednodejs/context'
require 'spec'
require 'spec/autorun'

require 'erb'
def rputs(msg)
  puts "<div>#{ERB::Util.h(msg)}</div>"
  $stdout.flush
end

Spec::Runner.configure do |config|
  
end
