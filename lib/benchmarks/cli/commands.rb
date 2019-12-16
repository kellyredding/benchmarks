# require "benchmarks/cli/clirb"
# require "much-plugin"

module Benchmarks; end
class Benchmarks::CLI

  # InvalidCommandError = Class.new(ArgumentError)
  # CommandExitError    = Class.new(RuntimeError)

  # class InvalidCommand
  #   attr_reader :name, :clirb

  #   def initialize(name)
  #     @name  = name
  #     @clirb = CLIRB.new
  #   end

  #   def new; self; end

  #   def run(argv)
  #     @clirb.parse!([@name, argv].flatten.compact)
  #     raise CLIRB::HelpExit if @name.to_s.empty?
  #     raise InvalidCommandError, "`#{self.name}` is not a command."
  #   end

  #   def help
  #     "Usage: bench [COMMAND] [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Commands:\n" \
  #     "#{COMMANDS.to_s.split("\n").map{ |l| "  #{l}" }.join("\n")}\n"
  #   end
  # end

  # module ValidCommand
  #   include MuchPlugin

  #   plugin_instance_methods do
  #     def initialize(&clirb_build)
  #       @clirb = CLIRB.new(&clirb_build)
  #     end

  #     def clirb; @clirb; end

  #     def run(argv, stdout = nil, stderr = nil)
  #       @clirb.parse!(argv)
  #       @stdout = stdout || $stdout
  #       @stderr = stderr || $stderr
  #     end

  #     def summary
  #       ""
  #     end
  #   end
  # end

  # module NotifyCmdCommand
  #   include MuchPlugin

  #   plugin_instance_methods do
  #     private

  #     def notify(success_msg, &cmd_block)
  #       cmd(&cmd_block)
  #       @stdout.puts success_msg
  #     end

  #     def cmd(&cmd_block)
  #       cmd, status, output = cmd_block.call
  #       if ENV["DEBUG"]
  #         @stdout.puts cmd
  #         @stdout.puts output
  #       end
  #     end
  #   end
  # end

  # module GitRepoCommand
  #   include MuchPlugin

  #   plugin_included do
  #     include ValidCommand
  #     include NotifyCmdCommand
  #     include InstanceMethods
  #   end

  #   module InstanceMethods
  #     def initialize(*args)
  #       super

  #       require "ggem/git_repo"
  #       @repo = Benchmarks::GitRepo.new(Dir.pwd)
  #     end

  #     private

  #     def notify(*args, &block)
  #       begin
  #         super
  #       rescue Benchmarks::GitRepo::CmdError => exception
  #         @stderr.puts exception.message
  #         raise CommandExitError
  #       end
  #     end

  #   end
  # end

  # class GenerateCommand
  #   include GitRepoCommand

  #   def run(argv, *args)
  #     super

  #     begin
  #       require "ggem/gem"
  #       path = Benchmarks::Gem.new(Dir.pwd, @clirb.args.first).save!.path
  #       @stdout.puts "created gem in #{path}"
  #     rescue Benchmarks::Gem::NoNameError => exception
  #       error = ArgumentError.new("GEM-NAME must be provided")
  #       error.set_backtrace(exception.backtrace)
  #       raise error
  #     end

  #     @repo = Benchmarks::GitRepo.new(path)
  #     notify("initialized gem git repo"){ @repo.run_init_cmd }
  #   end

  #   def summary
  #     "Create a gem given a GEM-NAME"
  #   end

  #   def help
  #     "Usage: ggem generate [options] GEM-NAME\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}"
  #   end

  # end

  # module GemspecCommand
  #   include MuchPlugin

  #   plugin_included do
  #     include ValidCommand
  #     include NotifyCmdCommand
  #     include InstanceMethods
  #   end

  #   module InstanceMethods
  #     def initialize(*args)
  #       super

  #       require "ggem/gemspec"
  #       begin
  #         @spec = Benchmarks::Gemspec.new(Dir.pwd)
  #       rescue Benchmarks::Gemspec::NotFoundError => exception
  #         error = ArgumentError.new("There are no gemspecs at #{Dir.pwd}")
  #         error.set_backtrace(exception.backtrace)
  #         raise error
  #       end
  #     end

  #     private

  #     def notify(*args, &block)
  #       begin
  #         super
  #       rescue Benchmarks::Gemspec::CmdError => exception
  #         @stderr.puts exception.message
  #         raise CommandExitError
  #       end
  #     end

  #   end
  # end

  # class BuildCommand
  #   include GemspecCommand

  #   def run(argv, *args)
  #     super
  #     notify("#{@spec.name} #{@spec.version} built to #{@spec.gem_file}") do
  #       @spec.run_build_cmd
  #     end
  #   end

  #   def summary
  #     "Build #{@spec.gem_file_name} into the " \
  #     "#{Benchmarks::Gemspec::BUILD_TO_DIRNAME} directory"
  #   end

  #   def help
  #     "Usage: ggem build [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}"
  #   end

  # end

  # class InstallCommand
  #   include GemspecCommand

  #   def initialize(*args)
  #     super
  #     @build_command = BuildCommand.new(*args)
  #   end

  #   def run(argv, *args)
  #     super
  #     @build_command.run([])

  #     notify("#{@spec.name} #{@spec.version} installed to system gems") do
  #       @spec.run_install_cmd
  #     end
  #   end

  #   def summary
  #     "Build and install #{@spec.gem_file_name} into system gems"
  #   end

  #   def help
  #     "Usage: ggem install [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}"
  #   end

  # end

  # class PushCommand
  #   include GemspecCommand

  #   def initialize(*args)
  #     super
  #     @build_command = BuildCommand.new(*args)
  #   end

  #   def run(argv, *args)
  #     super
  #     @build_command.run([])

  #     @stdout.puts "Pushing #{@spec.gem_file_name} to #{@spec.push_host}..."
  #     notify("#{@spec.gem_file_name} received.") do
  #       @spec.run_push_cmd
  #     end
  #   end

  #   def summary
  #     "Push built #{@spec.gem_file_name} to #{@spec.push_host}"
  #   end

  #   def help
  #     "Usage: ggem push [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}"
  #   end

  # end

  # module ForceTagOptionCommand
  #   include MuchPlugin

  #   plugin_included do
  #     include ValidCommand
  #     include InstanceMethods
  #   end

  #   module InstanceMethods

  #     def initialize
  #       super do
  #         option "force-tag", "force tagging even with uncommitted files", {
  #           :abbrev => "f"
  #         }
  #       end
  #     end

  #   end

  # end

  # class TagCommand
  #   include GitRepoCommand
  #   include GemspecCommand
  #   include ForceTagOptionCommand

  #   def run(argv, *args)
  #     super

  #     begin
  #       cmd{ @repo.run_validate_clean_cmd }
  #       cmd{ @repo.run_validate_committed_cmd }
  #     rescue Benchmarks::GitRepo::CmdError => err
  #       @stderr.puts "There are files that need to be committed first."
  #       if self.clirb.opts["force-tag"]
  #         @stderr.puts "Forcing tag anyway..."
  #       else
  #         raise CommandExitError
  #       end
  #     end

  #     cmd{ @repo.run_add_version_tag_cmd(@spec.version, @spec.version_tag) }

  #     @stdout.puts "Tagged #{@spec.version_tag}."

  #     begin
  #       cmd{ @repo.run_push_cmd }
  #     rescue
  #       cmd{ @repo.run_rm_tag_cmd(@spec.version_tag) }
  #       raise
  #     end

  #     @stdout.puts "Pushed git commits and tags."
  #   rescue Benchmarks::GitRepo::CmdError => err
  #     @stderr.puts err.message
  #     raise CommandExitError
  #   end

  #   def summary
  #     "Tag #{@spec.version_tag} and push git commits/tags"
  #   end

  #   def help
  #     "Usage: ggem tag [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}"
  #   end

  # end

  # class ReleaseCommand
  #   include GemspecCommand
  #   include ForceTagOptionCommand

  #   def initialize(*args)
  #     super
  #     @tag_command  = TagCommand.new(*args)
  #     @push_command = PushCommand.new(*args)
  #   end

  #   def run(argv, *args)
  #     super
  #     @tag_command.run(self.clirb.opts["force-tag"] ? ["--force-tag"] : [])
  #     @push_command.run([])
  #   end

  #   def summary
  #     "Tag #{@spec.version_tag} and push built #{@spec.gem_file_name} to " \
  #     "#{@spec.push_host}"
  #   end

  #   def help
  #     "Usage: ggem release [options]\n\n" \
  #     "Options: #{@clirb}\n" \
  #     "Description:\n" \
  #     "  #{self.summary}\n" \
  #     "  (macro for running `ggem tag && ggem push`)"
  #   end

  # end
end
