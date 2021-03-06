require_relative 'spec_helper'

describe 'nxlog::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs nxlog' do
    expect(chef_run).to create_remote_file('nxlog').with_checksum(
      '0dd942ee06c8c364e7c929102ae0a6174ddc2e3c6e9a9fe863f5b94bdb93da3c'
    )
    expect(chef_run).to install_dpkg_package('nxlog')
    expect(chef_run).to enable_service('nxlog')
  end

  it 'creates a config file' do
    expect(chef_run).to render_file('/etc/nxlog/nxlog.conf')
      .with_content(/User *nxlog/)
    expect(chef_run).not_to render_file('/etc/nxlog/nxlog.conf')
      .with_content(/SpoolDir/)

    expect(chef_run.service('nxlog')).to(
      subscribe_to('template[/etc/nxlog/nxlog.conf]'))
  end

  it 'creates a config directory' do
    expect(chef_run).to create_directory('/etc/nxlog/nxlog.conf.d')
  end
end
