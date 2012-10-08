Introduction
============

This document describes the API of the OpenStreetMap Activity Server.

Some definitions for terms used in this document:

* Activity - a JSON document according to the JSON Activity Streams 1.0 specification
* Activity stream - a collection of activities serialized as described in the specification

API
===

Retrieving an activity stream
-----------------------------

**URL:** `/activities`  
**Method:** GET

**Supported request parameters:**

* `user_id` - OSM user id
* `bbox` - bounding box
* `format` - can be either `json` or `rss` (defaults to `json`)

**Response:**

Activity stream according to given parameters.

**Example:**

`/activities?user_id=1234&format=rss`

Creating new activity
---------------------

**URL:** `/activities`  
**Method:** POST

**Supported request parameters:**

* `json` -  is expected to contain a JSON document representing an activity;
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
