require "benchmarks/cli/compact_map_command_behaviors"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class ChainMapCompact
    include Benchmarks::CLI::CompactMapCommandBehaviors

    def algorithm_title
      "items.map{ |e| e.to_s if e }.compact"
    end

    def algorithm
      ->(items) { items.map{ |e| e.to_s if e }.compact }
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
