# Ensure the DNF cache is up to date
execute 'dnf_makecache' do
  command 'dnf makecache'
  action :run
end

# Install Docker and Docker Compose plugin using dnf
package %w(docker docker-compose-plugin) do
  action :install
  notifies :enable, 'service[docker]', :immediately
  notifies :start, 'service[docker]', :immediately
end

# Enable and start Docker service
service 'docker' do
  action [:enable, :start]
end
