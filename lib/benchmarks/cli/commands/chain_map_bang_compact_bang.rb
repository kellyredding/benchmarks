require "benchmarks/cli/valid_command_behaviors"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class ChainMapBangCompactBang
    include Benchmarks::CLI::ValidCommandBehaviors

    def run(argv, *args)
      super

      begin
        require "whysoslow"

        printer = ::Whysoslow::DefaultPrinter.new({
          :title => "Chain Map Bang Compact Bang",
          :verbose => true
        })
        runner = Whysoslow::Runner.new(printer)

        runner.run do
          (1..10_000_000).to_a.map!(&:to_s).tap(&:compact!)
        end
      end
    end

    def summary
      "Chain Map Bang Compact Bang"
    end

    def help
      "Usage: bench chain-map-bang-compact-bang\n\n" \
      "Options: #{@clirb}\n" \
      "Description:\n" \
      "  #{self.summary}"
    end
  end

end
