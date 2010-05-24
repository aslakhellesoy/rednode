require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rednodejs" do
  def node(main_js)
    begin
      @node = Rednodejs::Context.new
      @node.run(main_js)
    rescue V8::JavascriptError => e
      e.backtrace << "*** Here goes the Javascript trace ***"
      e.backtrace << e.javascript_stacktrace
      raise e
    end
  end

  it "should read files" do
    node('spec/files.js')
  end
end
