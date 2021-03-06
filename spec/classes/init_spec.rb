require 'spec_helper'

describe 'consul' do

  # Installation Stuff
  context 'On an unsupported arch' do
    let(:facts) {{ :architecture => 'bogus' }}
    let(:params) {{
      :install_method => 'package'
    }}
    it { expect { should compile }.to raise_error(/Unsupported kernel architecture:/) }
  end
  context 'When requesting to install via a package with defaults' do
    let(:facts) {{ :architecture => 'x86_64' }}
    let(:params) {{
      :install_method => 'package'
    }}
    it { should contain_package('consul').with(:ensure => 'latest') }
  end
  context 'When requesting to install via a custom package and version' do
    let(:facts) {{ :architecture => 'x86_64' }}
    let(:params) {{
      :install_method => 'package',
      :package_ensure => 'specific_release',
      :package_name   => 'custom_consul_package'
    }}
    it { should contain_package('custom_consul_package').with(:ensure => 'specific_release') }
  end
  context "When installing via URL by default" do
    let(:facts) {{ :architecture => 'x86_64' }}
    it { should contain_archive('consul').with(:url => 'https://dl.bintray.com/mitchellh/consul/0.1.0_linux_amd64.zip') }
  end
  context "When installing via URL by with a special version" do
    let(:params) {{
      :version   => '42',
    }}
    let(:facts) {{ :architecture => 'x86_64' }}
    it { should contain_archive('consul').with(:url => 'https://dl.bintray.com/mitchellh/consul/42_linux_amd64.zip') }
  end
  context "When installing via URL by with a custom url" do
    let(:facts) {{ :architecture => 'x86_64' }}
    let(:params) {{
      :download_url   => 'http://myurl',
    }}
    it { should contain_archive('consul').with(:url => 'http://myurl') }
  end

  context "By default, a user should be installed" do
    let(:facts) {{ :architecture => 'x86_64' }}
    it { should contain_user('consul').with(:ensure => :present) }
  end
  context "When asked not to manage the user" do
    let(:facts) {{ :architecture => 'x86_64' }}
    let(:params) {{ :manage_user => false }}
    it { should_not contain_user('consul') }
  end
  context "With a custom username" do
    let(:facts) {{ :architecture => 'x86_64' }}
    let(:params) {{ :user => 'custom_consul_user' }}
    it { should contain_user('custom_consul_user').with(:ensure => :present) }
    it { should contain_file('/etc/init/consul.conf').with_content(/setuid custom_consul_user/) }
  end

  # Config Stuff

  # Service Stuff

end
