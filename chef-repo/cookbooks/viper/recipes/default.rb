#
# Cookbook Name:: viper
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git-core"

directory "/opt/viper"

deploy "/opt/viper" do
  repository "https://github.com/nestorsalceda/viper.git"
  branch "master"
  symlink_before_migrate({})
  symlinks({})
  create_dirs_before_symlink([])
  before_symlink do

    python_virtualenv "#{release_path}/virtualenv" do
      interpreter "python2.7"
      action :create
    end

    execute "install viper" do
      cwd "#{release_path}"
      command ". ./virtualenv/bin/activate && python setup.py develop"
    end
  end

  before_restart do
    databases = []
    if node[:roles].include?("database")
      databases << node
    end
    databases.concat(search(:node, "roles:database"))
    database = databases.first

    supervisor_service "viper" do
      action :enable
      command "/opt/viper/current/virtualenv/bin/python /opt/viper/current/launcher.py --mongodb_host=#{database[:network][:interfaces][:eth1][:addresses].select{|key,val| val[:family] == 'inet'}.flatten[0]} --mongodb_port=#{database[:mongodb][:port]}"
    end
  end

  restart do
    supervisor_service "viper" do
      action :restart
    end
  end
end
