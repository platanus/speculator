# Surbtc Bots
This is a Rails application, initially generated using [Potassium](https://github.com/platanus/potassium) by Platanus.

## Local installation
Assuming you've just cloned the repo:
- Run 'bundle' to get your gems ready.
- Make sure you have Mysql running on your computer, or configure an external Mysql endpoint to work with.
- Run 'rake db:setup' to create your tables.
- Run 'rails s' and watch puma start

## External services
TODO: add external services here

## Deployment

This project is pre-configured to be (easily) deployed to Heroku servers, but needs you to have the Potassium binary installed. If you don't, then run:
```shell
$ gem install potassium
```
- Another prerequisite that you probably already meet, is having the Heroku Toolbelt installed. If you don't have it, type:
```
$ brew install heroku-toolbelt
```
- Then, make sure you have the permissions required to create an app on the Company Heroku Account. On Platanus right now, this means having access to the Platanus Founders shared 1Password vault :) If you do, go ahead and login to Heroku using the mentioned credentials:
```
$ heroku login
```
- Only then, you are ready to run
```shell
$ potassium heroku create
```
this will create the app on heroku, create a pipeline and link the app to the pipeline.

You'll still have to log in to the heroku dahsboard via browser, go see the newly created pipeline and 'configure automatic deploys' using Github

![Hint](https://cloud.githubusercontent.com/assets/313750/13019759/fa86c8ca-d1af-11e5-8869-cd2efb5513fa.png)

Remember to connect each stage to the corresponding branch:

1. Staging -> Master
2. Production -> Production

That's it. You should already have a running app and each time you push to the corresponding branch, the system will (hopefully) update accordingly.

## Internal dependencies

### Authentication
We are using the great [Devise](https://github.com/plataformatec/devise) library by [PlataformaTec](http://plataformatec.com.br/)
and contains a built-in **** Model### Admin
As a way to speed up development of an admin interface, we're using [ActiveAdmin](https://github.com/activeadmin/activeadmin)

## Continuous Integrations

The project is setup to run tests
in [CircleCI](https://circleci.com/gh/platanus/speculator/tree/master)

You can also run the test locally simulating the production environment using docker.
Just make sure you have docker installed and run:

    bin/cibuild

