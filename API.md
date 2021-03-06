Introduction
============

This document describes the API of the OpenStreetMap Activity Server. Please refer to the README.md file to get more high level/non-technical overview.

Some definitions for terms used in this document:

* Spec - refers to the [JSON Activity Streams specification](http://activitystrea.ms/specs/json/1.0/) 
* Activity document - a JSON document representing an Activity structured according to the Spec
* Activity stream - a collection of activities serialized as described in the Spec


API
===

Retrieving an activity stream
-----------------------------

Activity stream can be retrieved using a following HTTP request:

**URL:** `/activities`  
**Method:** GET

**Supported request parameters:**

* `actor_id` - OSM user id that will be used to generate the returned activity stream; returned stream will only contain activities where user with given user id is the actor
* `bbox` - bounding box (```minlat,minlon,maxlat,maxlon```) that will be used to generate the returned activity stream; returned stream will only contain activities which geometry (or at least part of it) is within given bounding box
* `format` - can be either `json` or `rss` (defaults to `json`)

**Response:**

Activity stream according to given parameters.

In case `format` request parameter was set to `json`, the response is just a collection of Activity documents serialized [according to the spec](http://activitystrea.ms/specs/json/1.0/#collection).

**Example:**

`/activities?user_id=1234&format=rss`

Creating new activity
---------------------

**URL:** `/activities`  
**Method:** POST

**Supported request parameters:**

* `json` - expected to contain a JSON document representing an activity;
          document format is described in the specification: http://activitystrea.ms/specs/json/1.0/#activity

**Response:**

JSON document describing the activity as it has been saved in the server (i.e. containing "published" timestamp etc).

**Example:**

JSON document for the request:

    {
        "actor": {
          "objectType" : "person",
          "id": "#{user_id}",
          "display_name": "#{user_name}"
        },
        "verb": "map",
        "object" : {
          "objectType" : "changeset",
          "id": "#{changeset_id}",
          "bbox": ""
        },
        "target" : {
          "objectType": "website",
          "url": "http://www.openstreetmap.org/"
        },
        "title" : "#{title}",
        "content" : "#{content}",
        "to" : [
          {"objectType": "userGroup", "id": "friends"}
        ]
    }
