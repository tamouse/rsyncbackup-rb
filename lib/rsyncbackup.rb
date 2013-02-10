require "rsyncbackup/version"
require "rsyncbackup/utilities"
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
      rsync_cmd: `which rsync`.chomp
    }.merge(opts)
    
    debug "options: #{options.inspect}"
  end
end
