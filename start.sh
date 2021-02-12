#!/bin/sh

# start sync process
/application/sync-entries &

nginx -g "daemon off;"
