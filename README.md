OpenStreetMap Activity Server
=============================

Making OpenStreetMap a little bit more social ;-)

## What is this?

OpenStreetMap Activity Server is a simple server application that is a central component of the activity stream implementation for the OpenStreetMap project.

The idea is to have a server for activities in order to implement the functionality without putting additional load on the main application and database servers in the OSM infrastructure.

A lot of terminology and technical stuff (data model in particular) is derived from the Activity Streams specification:

http://activitystrea.ms/

## What does it do?

It has several responsibilities:

* Accept, process and store new activities.
* Serve activity streams (a collection of activities).

## API

### Creating new activity

URL: http://<hostname>:<port>/activity/new
Request: POST with request parameter named "json"

Parameter "json" is expected to contain a JSON document representing an activity. Format is described in the specification:

http://activitystrea.ms/specs/json/1.0/#activity

### Retrieving an activity stream

TBD
