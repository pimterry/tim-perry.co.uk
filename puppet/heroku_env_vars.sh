#!/bin/sh
export PORT=8080
export RACK_ENV=development
export DATABASE_URL=postgres://postgres@localhost/blog
export NEW_RELIC_APPLICATION_NAME=tim-perry-dev
export NEW_RELIC_LICENSE_KEY=0 # Not real, obviously

export ADMIN_USERNAME=admin
export ADMIN_PASSWORD=password