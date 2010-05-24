require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rednodejs" do
  before do
    begin
      @node = Rednodejs::Context.new
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
