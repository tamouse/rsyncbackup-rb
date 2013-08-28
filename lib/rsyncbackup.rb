require "rsyncbackup/version"
require "rsyncbackup/utilities"
require 'open3'
require 'methadone'

class Rsyncbackup
  include Methadone::CLILogging
    
  attr_accessor :source, :target, :options, :output, :error, :status

  def initialize(source, target, opts={})
    logger.level = Logger::WARN
    logger.level = Logger::INFO if opts[:verbose]
    logger.error_level = Logger::DEBUG if opts[:debug]

    raise "Unknown target: #{target}" unless File.exist?(target) or opts[:dry_run]

    @source     = strip_trailing_separator_if_any(source,true)
    @target     = strip_trailing_separator_if_any(target)

    @options = {
      :dry_run         => false,
      :exclusions      => DEFAULT_EXCLUSIONS,
      :archive         => true,
      :one_file_system => true,
      :hard_links      => true,
      :human_readable  => true,
      :inplace         => true,
      :numeric_ids     => true,
      :delete          => true,
      :link_dest       => last_full_backup,
      :rsync_cmd       => rsync_executable
    }.merge(opts)
    
    @incomplete = File.join(target,DEFAULT_INCOMPLETE_DIR_NAME)
    @complete   = File.join(target,backup_dir_name)
    
    
    debug "#{caller(0,1).first} @source: #{@source}, @target: #{@target}, @options: #{@options.inspect}"

  end


  def run
    @cmd = build_command
    
    info "Backing up #{@source} to #{@target} on #{Time.now}"
    info "Rsync command: #{@cmd}"
    info "Dry run only" if options[:dry_run]
      
    if File.exist? temp_target_path
      warn "Preexisting temporary target. Moving it aside."
      File.rename temp_target_path, "#{temp_target_path}-#{Time.now.to_i}"
    end

    # the dry run option will be passed through to the rsync command,
    # so we still do want to run it.
    self.output, self.error, self.status = Open3.capture3(@cmd)
    debug "#{caller(0,1).first} self.output.size: #{self.output.size} self.error.size: #{self.error.size} self.status #{self.status.inspect}"
    raise "Rsync Error: exit status: #{self.status.exit_code}: error: #{e}" unless self.status.success?
    self
  end

  def success?
    (@status.nil?) ? nil : @status.success?
  end

  def finalize
    File.rename(@incomplete, @complete) if File.exist?(@incomplete)
    File.write(File.join(@target,DEFAULT_LAST_FULL_DIR_NAME), backup_dir_name)
    info "Backup saved in #{@complete}"
  end


end
