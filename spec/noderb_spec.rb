require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Noderb" do
  it "should load v8 and be happy" do
    begin
      cxt = Node::Context.new
      cxt.load('server.js')
    rescue V8::JavascriptError => e
      e.backtrace << "*** Here goes the Javascript trace ***"
      e.backtrace << e.javascript_stacktrace
      raise e
    end
  end
end
