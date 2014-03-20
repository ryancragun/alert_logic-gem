require 'spec_helper'

describe AlertLogic::Utils, '.pluralize' do
  before do
    class UtilTest; include AlertLogic::Utils; end
  end
  let(:utils) { UtilTest.new }

  it 'pluralizes words that dont end in y' do
    utils.send(:pluralize, 'appliance').should eq('appliances')
    utils.send(:pluralize, 'host').should eq('hosts')
    utils.send(:pluralize, 'protected_host').should eq('protected_hosts')
  end

  it 'pluralizes words that end in y' do
    utils.send(:pluralize, 'angry').should eq('angries')
    utils.send(:pluralize, 'policy').should eq('policies')
    utils.send(:pluralize, 'catastrophy').should eq('catastrophies')
  end

  it 'appends ies to trailing y in words with multiple ys' do
    utils.send(:pluralize, 'anyway').should eq('anywaies')
    utils.send(:pluralize, 'byway').should eq('bywaies')
    utils.send(:pluralize, 'layaway').should eq('layawaies')
    utils.send(:pluralize, 'yawey').should eq('yaweies')
  end
end
