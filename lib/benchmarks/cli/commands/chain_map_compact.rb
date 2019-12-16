require "benchmarks/cli/valid_command_behaviors"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class ChainMapCompact
    include Benchmarks::CLI::ValidCommandBehaviors

    def run(argv, *args)
      super

      begin
        require "whysoslow"

        printer = ::Whysoslow::DefaultPrinter.new({
          :title => "Chain Map Compact",
          :verbose => true
        })
        runner = Whysoslow::Runner.new(printer)

        runner.run do
          (1..10_000_000).to_a.map(&:to_s).compact
        end
      end
    end

    def summary
      "Chain Map Compact"
    end

    def help
      "Usage: bench chain-map-compact\n\n" \
      "Options: #{@clirb}\n" \
      "Description:\n" \
      "  #{self.summary}"
    end
  end

end
