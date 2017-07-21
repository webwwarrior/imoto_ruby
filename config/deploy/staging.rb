set :domain, '78.46.54.69'
set :deploy_to, '/home/imoto/apps/staging'
set :repository, 'git@gl.jetru.by:imoto/imoto-api.git'
set :branch, ENV['BRANCH'] || 'master'
set :commit, ENV['COMMIT']
set :rails_env, 'staging'
set :user, 'imoto'
set :port, '10022'
