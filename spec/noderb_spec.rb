require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'stringio'

describe "Rednodejs" do
  def node(main_js)
    begin
      @io = StringIO.new
      @node = Rednodejs::Context.new
      @node['specputs'] = proc {|msg| @io.puts(msg.to_s); @io.flush}
      @node.run(main_js)
    rescue V8::JavascriptError => e
      e.backtrace << "*** Here goes the Javascript trace ***"
      e.backtrace << e.javascript_stacktrace
      raise e
    end
  end

  def assert_io(expected)
    @io.rewind
    @io.read.should == expected
  end

  it "should load fs and sys" do
    node('spec/files.js')
    assert_io("WooooooooT\n");
  end
end
