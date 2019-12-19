require "benchmarks/cli/compact_map_command_behaviors"

module Benchmarks; end
class Benchmarks::CLI; end
module Benchmarks::CLI::Commands

  class CompactMap
    include Benchmarks::CLI::CompactMapCommandBehaviors

    def algorithm_title
      "items.compact_map{ |e| e.to_s if e }"
    end

    def algorithm
      ->(items) { items.compact_map{ |e| e.to_s if e } }
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
