require "benchmarks/cli/valid_command_behaviors"
require "benchmarks/enumerable"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class CompactMap
    include Benchmarks::CLI::ValidCommandBehaviors

    def run(argv, *args)
      super

      begin
        require "whysoslow"

        printer = ::Whysoslow::DefaultPrinter.new({
          :title => "Compact Map",
          :verbose => true
        })
        runner = Whysoslow::Runner.new(printer)

        runner.run do
          (1..10_000_000).to_a.compact_map(&:to_s)
        end
      end
    end

    def summary
      "Compact Map"
    end

    def help
      "Usage: bench compact-map\n\n" \
      "Options: #{@clirb}\n" \
      "Description:\n" \
      "  #{self.summary}"
    end
  end

end
