Memento
=======
Just a website where bookmark interesting links and read your RSS feeds.

*Memento* is currently running at [http://memento.giovannicapuano.net](http://memento.giovannicapuano.net).

Put the world in production
---------------------------
First of all, configure correctly `config/database.yml` and `config/initializers/recaptcha.rb`.

```sh
$ bundle install --deployment --without development test
$ bundle exec rake db:setup RAILS_ENV=production
$ bundle exec rake assets:precompile RAILS_ENV=production
$ rails  server --environment=production
```
