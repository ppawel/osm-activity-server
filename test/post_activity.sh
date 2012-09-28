#!/bin/bash

curl -X POST http://localhost:4567/activity/new --data-urlencode json@$1
