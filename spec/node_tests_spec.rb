require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'stringio'

describe "Rednode" do
  
  golden = eval(File.read(File.dirname(__FILE__) + '/golden.rb'))
  defined = {}
  for package in ['simple', 'pummel'] do
    defined[package] = []
    describe package do
      addspec = proc do |pkg, name, main|
        if golden[pkg].include?(name)
          it "#{name} works" do
            Rednode::Node.new(main).start
          end
        else
          it "#{name} works"
        end
      end
      for testfile in Dir["#{File.join(Rednode::NODE_HOME, 'test', package)}/test-*.js"]
        testfile =~ /.*\/test-(.*)\.js$/
        testname = $1
        addspec[package, testname, testfile]
        defined[package] << testname
      end
    end
    undefined = golden[package] - defined[package]
    unless undefined.empty?
      warn("we're expecting to pass tests in #{package} that don't exist: #{undefined.join(', ')}")
    end
  end
end
