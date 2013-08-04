require 'spec_helper'
require 'rsyncbackup'
require 'tempfile'

describe Rsyncbackup do
  
  let(:source){Dir.mktmpdir("source")}
  let(:target){Dir.mktmpdir("target")}
  before(:each) do
    Dir.chdir(source) do |pwd|
      %w{one two three four five}.each do |d|
        FileUtils.mkdir(File.join(pwd,d))
        %w{a b c d e f g}.each do |fn|
          File.open(File.join(d,fn),'w') do |f|
            f.puts "Test file for #{example.description}"
            f.puts Time.now.to_s
          end
        end
      end
    end
  end

  context "Interface Checks" do
    it "should respond to :new" do
      Rsyncbackup.should respond_to(:new)
    end

    it "should be of type Rsyncbackup" do
      Rsyncbackup.new(source, target, :dry_run => true).should be_a(Rsyncbackup)      
    end

  end
  
  context "Options Validity" do
    let(:syncer) { Rsyncbackup.new(source, target, :dry_run => true) }

    it "has a command" do
      syncer.options[:rsync_cmd].should =~ /rsync/
    end
    
  end

  context "#run" do
    let(:syncer) { Rsyncbackup.new(source, target, :dry_run => true) }
    it "should respond to :run" do
      syncer.should respond_to(:run)
    end
  end

  context "#finalize" do
    let(:syncer) { Rsyncbackup.new(source,target) }
    it "should respond to :finalize" do
      syncer.should respond_to(:finalize)
    end

    it "should rename temporary backup directory" do
      syncer.run
      syncer.finalize
      File.exist?(File.join(target,Rsyncbackup::DEFAULT_INCOMPLETE_DIR_NAME)).should be_false
      File.exist?(File.join(target,Rsyncbackup::DEFAULT_LAST_FULL_DIR_NAME)).should be_true
      File.directory?(File.join(target,syncer.backup_dir_name)).should be_true
      File.directory?(File.join(target,syncer.backup_dir_name,File.basename(source))).should be_true
    end
  end
end

