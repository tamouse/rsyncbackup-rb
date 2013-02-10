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

end
