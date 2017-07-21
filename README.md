# README
### Ruby and Rails version
    - Ruby 2.3.1
    - Rails 5.0.0.1

### STAGING
http://api.staging-imoto.jetru.by/graphiql

### ADMIN DASHBOARD
http://api.staging-imoto.jetru.by/admins/sign_in

* Email: admin@example.com

* Password: password

### Getting Started
---------------
```ShellSession
cp .ruby-version.tt .ruby-version
cp .ruby-gemset.tt .ruby-gemset
```

* System dependencies

* Configuration

### Set up Overcommit
```ShellSession
gem install overcommit
overcommit --install
overcommit --sign
```

### Run server
```ShellSession
bundle exec rails s
```

### Database creation
```ShellSession
bundle exec rails db:create db:migrate
```

### Import zip codes
```
bundle exec rake app:import_zip_codes
```

### Database initialization
```ShellSession
cp config/secrets.yml.tt config/secrets.yml
cp config/database.yml.tt config/database.yml # then update with your postgres username and password credentials
```

### How to run the test suite
  ```ShellSession
bundle exec rspec spec
  ```

### Run google webhooks on local server
 Add authtoken for ngrok
```ShellSession
 ./ngrok authtoken 'some value'
```
```ShellSession
./ngrok http --subdomain=imoto-development 3000
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
