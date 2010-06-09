require 'rednode'
begin
  require 'rspec/autorun'
rescue LoadError
  require 'rubygems'
  require 'rspec/autorun'
end

require 'erb'
def rputs(msg)
  puts "<div>#{ERB::Util.h(msg)}</div>"
  $stdout.flush
end
