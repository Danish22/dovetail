# README #

### What is this repository for? ###

This is the repo for the Dovetail co-working space management app.

### How do I get set up? ###

* Ruby 2.1.2, Rails 4.1.1
* cp config/database-sample.yml -> config/database.yml - Edit as appropriate.
* cp config/application-sample.yml -> config/application.yml - Edit as appropriate
* Using Mailcatcher for capturing emails sent in development mode
* bundle install
* bundle exec rake db:create
* bundle exec db:schema:load
* bundle exec rails server
* http://lvh.me:3000/

### Contributing ###

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

### Who do I talk to? ###

* Vince Hodges vhodges@gmail.com
* Matt Farely matt@pendeavor.com

## License

Dovetail is Copyright © 2016 Vince Hodges and Matt Farley. It is free
software, and may be redistributed under the terms specified in the [LICENSE](LICENSE) file.
