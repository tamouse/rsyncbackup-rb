require 'spec_helper'
require 'rsyncbackup'

describe Rsyncbackup do
  
  context "Interface Checks" do
    it { Rsyncbackup.should respond_to(:new) }
    it { Rsyncbackup.new(source: 'source', target: 'target').should be_a(Rsyncbackup) }
  end
  
  context "Options Validity" do
    let(:syncer) { Rsyncbackup.new(source: 'source', target: 'target') }

    it "has a command" do
      syncer.options[:rsync_cmd].should =~ /rsync/
    end
    
  end

  context "#run" do

    def expect_command_match(part_of_command)
      Open3.stub(:popen3) do |command|
        mismatch_message = "mismatch!! expected:  #{part_of_command}. received:  #{command}"
        case part_of_command
        when Regexp
          raise mismatch_message unless command =~ part_of_command
        when String
          raise mismatch_message unless  command.include?(part_of_command)
        else
          raise mismatch_message
        end
      end
    end

    let(:source) {'features/test_files/source' }
    let(:target) {'features/test_files/target'}

    let(:syncer) { Rsyncbackup.new(source: source, target: target) }

    it { syncer.should respond_to(:run) }
    
    it "should allow a different executable" do
      exec="echo --"
      syncer.options[:rsync_cmd] = exec
      expect_command_match(exec)
      syncer.run
    end

    it "should allow a different exclusions file" do
      exclusions=File.expand_path("myexclusions")
      File.open(exclusions,'w') do |fh|
        fh.puts "my exclusions go here"
      end
      syncer.options[:exclusions]=exclusions
      expect_command_match("--exclude-file #{exclusions}")
      syncer.run
      File.unlink(exclusions)
    end

  end

  context "#finalize" do
    
    let(:source) {'features/test_files/source' }
    let(:target) {'features/test_files/target'}

    let(:syncer) { Rsyncbackup.new(source: source , target: target ) }
    it { syncer.should respond_to(:finalize) }

    it "should rename temporary backup directory" do
      syncer.run
      syncer.finalize
      File.exist?(File.join(target,'.lastfull')).should be_true
      File.directory?(File.join(target,syncer.backup_dir_name)).should be_true
      File.directory?(File.join(target,syncer.backup_dir_name,File.basename(source))).should be_true
    end
      



  end



end
