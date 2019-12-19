require "much-plugin"

require "benchmarks/cli/valid_command_behaviors"
require "benchmarks/enumerable"

module Benchmarks; end
class Benchmarks::CLI

  module CompactMapCommandBehaviors
    include MuchPlugin

    ITEMS = {
      :all_nils =>
        -> { Array.new(2_00_000, nil) },
      :half_nils =>
        -> { Array.new(1_000_000, 1).zip(Array.new(1_000_000, nil)).tap(&:flatten!) },
      :no_nils =>
        -> { Array.new(2_000_000, 1) }
    }

    plugin_included do
      include Benchmarks::CLI::ValidCommandBehaviors
    end

    plugin_instance_methods do
      def initialize
        super do
          option :all_nils
          option :half_nils
          option :no_nils
        end
      end

      def run(argv, *args)
        super

        option = @clirb.opts.select{ |k,v| !v.nil? }.keys.first
        raise Benchmarks::CLI::CLIRB::HelpExit unless option

        items = ITEMS[option.to_sym].call
        printer = ::Whysoslow::DefaultPrinter.new({
          :title => algorithm_title,
          :verbose => true
        })

        Whysoslow::Runner.new(printer).run { algorithm.call(items) }
      end

      def algorithm_title
        raise NotImplementedError
      end

      def algorithm
        raise NotImplementedError
      end
    end
  end

end
