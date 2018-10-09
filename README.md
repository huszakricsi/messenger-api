# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ruby-2.4.4

* System dependencies

* Configuration

* Database creation
```sh
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* How to access outside localhost

Let the port go through the firewall (3000)
Then:
```sh
$ rails server -b 0.0.0.0
```
* How to test the authentication from terminal

```sh
$ curl -v -X "POST" "http://localhost:3000/auth/sign_in" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d $'{
  "email": "user@mail.net",
  "password": "secretpassword"
}'
```