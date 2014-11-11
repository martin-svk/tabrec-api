# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{tabber@tabber.fiit.stuba.sk}
role :web, %w{tabber@tabber.fiit.stuba.sk}
role :db,  %w{tabber@tabber.fiit.stuba.sk}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'tabber.fiit.stuba.sk', user: 'tabber', roles: %w{web app db}

set :ssh_options, {
  keys: %w(/home/tabber/.ssh/id_rsa)
}
