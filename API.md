Creating new activity
---------------------

URL: /activities
Method: POST

Request parameters:

* json -  is expected to contain a JSON document representing an activity;
          document format is described in the specification: http://activitystrea.ms/specs/json/1.0/#activity

Response:

JSON document describing the activity as it has been saved in the server (i.e. containing "published" timestamp etc).

Retrieving an activity stream (3rd person view)
-----------------------------------------------

URL: /activities
Method: GET

Request parameters:

* user_id - OSM user id

Response:

A collection of JSON objects according to the specification: http://activitystrea.ms/specs/json/1.0/#collection
