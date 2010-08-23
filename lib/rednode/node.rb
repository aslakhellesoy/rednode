require 'v8'

module Rednode
  class Node

    attr_reader :engine, :main

    def initialize(main)
      @engine = V8::Context.new
      @node = @engine.load(File.join(NODE_HOME, 'src', 'node.js'))
      @main = main
    end

    def start
      @node.call(Process.new(self))
    end
  end
end