module Benchmarks; end
class Benchmarks::CLI

  class CommandSet
    def initialize(&unknown_cmd_block)
      @lookup    = Hash.new{ |h,k| unknown_cmd_block.call(k) }
      @names     = []
      @aliases   = {}
      @summaries = {}
    end

    def add(klass, name, *aliases)
      begin
        cmd = klass.new
      rescue StandardError => _err
        # don't add any commands you can't init
      else
        ([name] + aliases).each{ |n| @lookup[n] = cmd }
        @to_s = nil
        @names << name
        @aliases[name] = aliases.empty? ? "" : "(#{aliases.join(", ")})"
        @summaries[name] = cmd.summary.to_s.empty? ? "" : "# #{cmd.summary}"
      end
    end

    def remove(name)
      @lookup.delete(name)
      @names.delete(name)
      @aliases.delete(name)
      @to_s = nil
    end

    def [](name)
      @lookup[name]
    end

    def size
      @names.size
    end

    def to_s
      max_name_size  = @names.map{ |n| n.size }.max || 0
      max_alias_size = @aliases.values.map{ |v| v.size }.max || 0

      @to_s ||= @names.map do |n|
        "#{n.ljust(max_name_size)} #{@aliases[n].ljust(max_alias_size)} #{@summaries[n]}"
      end.join("\n")
    end
  end

end
