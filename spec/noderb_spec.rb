require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Node.rb" do
  before do
    begin
      @node = Node::Context.new
    rescue V8::JavascriptError => e
      e.backtrace << "*** Here goes the Javascript trace ***"
      e.backtrace << e.javascript_stacktrace
      raise e
    end
  end

  it "should read files" do
    @node.load('spec/files.js')
  end
end
