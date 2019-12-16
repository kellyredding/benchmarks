require "benchmarks/cli/clirb"

module Benchmarks; end
class Benchmarks::CLI

  class InvalidCommand
    attr_reader :name, :clirb

    def initialize(name)
      @name  = name
      @clirb = CLIRB.new
    end

    def new; self; end

    def run(argv)
      @clirb.parse!([@name, argv].flatten.compact)
      raise CLIRB::HelpExit if @name.to_s.empty?
      raise InvalidCommandError, "`#{self.name}` is not a command."
    end

    def help
      "Usage: bench [COMMAND] [options]\n\n" \
      "Options: #{@clirb}\n" \
      "Commands:\n" \
      "#{COMMANDS.to_s.split("\n").map{ |l| "  #{l}" }.join("\n")}\n"
    end
  end

end
