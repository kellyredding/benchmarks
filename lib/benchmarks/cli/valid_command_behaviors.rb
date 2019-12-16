require "benchmarks/cli/clirb"
require "much-plugin"

module Benchmarks; end
class Benchmarks::CLI

  module ValidCommandBehaviors
    include MuchPlugin

    plugin_instance_methods do
      def initialize(&clirb_build)
        @clirb = CLIRB.new(&clirb_build)
      end

      def clirb; @clirb; end

      def run(argv, stdout = nil, stderr = nil)
        @clirb.parse!(argv)
        @stdout = stdout || $stdout
        @stderr = stderr || $stderr
      end

      def summary
        ""
      end
    end
  end

end
