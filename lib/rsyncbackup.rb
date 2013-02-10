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
    
    if logger.warn? && options[:verbose] == true
      logger.level=Logger::INFO
    end

    debug "options: #{options.inspect}"

  end


  def run
    cmd = build_command
    
    info "Rsync command: #{cmd}"
    if options[:dry_run]
      info "Dry run only"
    end
      
    if File.exist? temp_target_path
      warn "Preexisting temporary target. Moving it aside."
      File.rename temp_target_path, "#{temp_target_path}-#{"%0.4d" % Random.rand(1000)}"
    end


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

  def finalize

    incomplete = "#{options[:target]}/.incomplete"
    complete = "#{options[:target]}/#{backup_dir_name}"

    if File.exist?(incomplete) &&
        !File.exist?(complete)
      File.rename(incomplete, complete)
    end
    
    File.open("#{options[:target]}/.lastfull",'w') do |fh|
      fh.puts backup_dir_name
    end

    info "Backup saved in #{options[:target]}/#{backup_dir_name}"
  end


end
