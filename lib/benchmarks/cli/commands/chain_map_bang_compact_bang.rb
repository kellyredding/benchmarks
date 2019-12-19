require "benchmarks/cli/compact_map_command_behaviors"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class ChainMapBangCompactBang
    include Benchmarks::CLI::CompactMapCommandBehaviors

    def algorithm_title
      "items.map!{ |e| e.to_s if e }.tap(&:compact!)"
    end

    def algorithm
      ->(items) { items.map!{ |e| e.to_s if e }.tap(&:compact!) }
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
