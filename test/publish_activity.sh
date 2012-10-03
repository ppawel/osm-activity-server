#!/bin/bash

curl -X POST http://localhost:3000/activities --data-urlencode json@$1
