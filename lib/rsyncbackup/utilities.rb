=begin rdoc

= UTILITIES.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

require 'methadone'

class Rsyncbackup
  
  # returns the command string to execute with all parameters set
  def build_command
    
    cmd = []
    cmd << options[:rsync_cmd]
    cmd << '--verbose --progress --itemize-changes' if logger.info?
    cmd << '--archive'             if options[:archive]
    cmd << '--one-file-system'     if options[:one_file_system]
    cmd << '--hard-links'          if options[:hard_links]
    cmd << '--human-readable'      if options[:human_readable]
    cmd << '--inplace'             if options[:inplace]
    cmd << '--numeric-ids'         if options[:numeric_ids]
    cmd << '--delete'              if options[:delete]
    cmd << "--exclude-file #{options[:exclusions]}" if File.exist?(options[:exclusions])
    cmd << "--link-dest #{options[:link_dest]}" if options[:link_dest]
    cmd << options[:source]
    cmd << "#{options[:target]}/.incomplete"
    
    cmd.join(' ').tap{|t| debug "Command: #{t}" }
    
  end
    
  # returns the directory name of the last full backup
  # returns nil otherwise
  def last_full_backup
    
    lastfull = "#{options[:target]}/.lastfull"
    if File.exist?(lastfull)
      last_full_directory = IO.readlines(lastfull).first.chomp
    else
      nil
    end

  end
  
  # returns the directory name for the current backup
  # directory name consists of a time format: YYYY-MM-DDTHH-MM-SS
  def backup_dir_name
    Date.new.strftime("%FT%H-%M-%S")
  end

  # returns the path to the rsync executable
  # If none found, raises an Exception
  def rsync_executable
    rsync = `which rsync`.chomp
    raise "No rsync executable. Are you sure it\'s installed?" if rsync.empty?
    rsync
  end

  # Strip the trailing directory separator from the rsync
  # source or target.
  #
  # *s*:: string to strip
  def strip_trailing_separator_if_any(s)
    raise "not a String" unless s.is_a?(String)
    s = s.gsub(%r{/$},'')
  end

end
