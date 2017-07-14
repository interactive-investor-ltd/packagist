template "#{release_path}/app/config/parameters.yml" do
  source "#{release_path}/deploy/parameters.yml.erb"
  owner "deploy"
  group "apache"
  mode "0644"
  local true
end

template "/etc/cron.d/packagist" do
  source "#{release_path}/deploy/packagist_cron.erb"
  owner "root"
  group "root"
  mode "0644"
  local true
  variables({
     :release_path => release_path
  })
end

composer_project "#{release_path}" do
    dev false
    quiet true
    prefer_dist false
    action :install
end

directory "#{release_path}/app/cache" do
    user deploy
    group apache
    mode '0775'
end

directory "#{release_path}/app/logs" do
    user deploy
    group apache
    mode '0775'
end

directory '/home/deploy/.composer' do
  owner 'deploy'
  group 'apache'
  mode '0775'
  action :create
end

execute "install web assets" do
  command "app/console assets:install web"
  cwd "#{release_path}"
  user "root"
end
