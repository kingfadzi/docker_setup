**Docker Setup with Chef**

This repository contains the `docker_setup` cookbook, which is used to install and configure Docker on a Fedora node using Chef Infra.

### Workstation Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/kingfadzi/docker_setup.git
   cd docker_setup
   ```

2. **Configure `knife.rb`:**

    - Create a `.chef` directory inside the repository:

      ```bash
      mkdir .chef
      ```

    - Create and edit the `knife.rb` file:

      ```bash
      nano .chef/knife.rb
      ```

    - Add the following content:

      ```ruby
      current_dir = File.dirname(__FILE__)
      log_level                :info
      log_location             STDOUT
      node_name                "fadzi"
      client_key               "~/.chef/CHEF_CREDS"
      chef_server_url          "https://sponde.butterflycluster.com/organizations/bcluster"
      cookbook_path            ["#{ENV['HOME']}/tools/chef-repo/cookbooks"]
      ```

3. **Add the `CHEF_CREDS` Key:**

   Copy your `CHEF_CREDS.pem` file to the `.chef` directory:

   ```bash
   cp /path/to/your/CHEF_CREDS.pem ~/.chef/
   ```

4. **Fetch and Trust SSL Certificates (if applicable):**

   If you encounter SSL validation errors when interacting with the Chef server, run the following command to fetch and trust the server's SSL certificate:

   ```bash
   knife ssl fetch
   ```

### Role Setup

1. **Create the Role File:**

    - Create a `roles` directory and add the `docker_role.json` file:

      ```bash
      mkdir -p roles
      nano roles/docker_role.json
      ```

    - Add the following content:

      ```json
      {
        "name": "docker_role",
        "description": "Role to configure Docker on nodes",
        "run_list": [
          "recipe[docker_setup::default]"
        ],
        "override_attributes": {
          "docker": {
            "version": "latest"
          }
        }
      }
      ```

2. **Upload the Role to Chef Server:**

   ```bash
   knife role from file roles/docker_role.json
   ```

### Cookbook Deployment

1. **Upload the Cookbook to Chef Server:**

   ```bash
   knife cookbook upload docker_setup
   ```

2. **Assign the Role to the Node:**

   ```bash
   knife node run_list add venus 'role[docker_role]'
   ```

3. **Run Chef Client on the Fedora Node:**

   SSH into the Fedora node and run the Chef client:

   ```bash
   sudo chef-client
   ```

---
