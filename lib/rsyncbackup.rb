require "rsyncbackup/version"
require "rsyncbackup/utilities"
require 'open3'
require 'methadone'

class Rsyncbackup
  include Methadone::CLILogging
    
  attr_accessor :options

  def initialize(opts={})
    @options = {
      dry_run: false,
      exclusions: DEFAULT_EXCLUSIONS,
      archive: true,
      one_file_system: true,
      hard_links: true,
      human_readable: true,
      inplace: true,
      numeric_ids: true,
      delete: true,
      rsync_cmd: rsync_executable
    }.merge(opts)
    
    options[:source] = strip_trailing_separator_if_any(options[:source])
    options[:target] = strip_trailing_separator_if_any(options[:target])

    options[:link_dest] ||= last_full_backup


    debug "options: #{options.inspect}"
  end


  def run
    cmd = build_command
    
    info "Rsync command: #{cmd}"
    if options[:dry_run]
      info "Dry run only"
    else
      
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait|
        stdin.close
        until stdout.eof?
          info stdout.gets
        end
        until stderr.eof?
          errors =  stderr.gets
        end
        result = wait.value
        raise "Command failed. Return code: #{result}\n#{errors}" unless result == 0
      end
    
    end
    
  end
end
