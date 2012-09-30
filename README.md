OpenStreetMap Activity Server
=============================

Making OpenStreetMap a little bit more social ;-)

## What is this?

OpenStreetMap Activity Server is a simple server that is a central component of the activity stream implementation for the OpenStreetMap project.

## Umm, right... but what is his "activity stream" you speak of?

According to Wikipedia:

*"An activity stream is a list of recent activities performed by an individual, typically on a single website."*

See http://en.wikipedia.org/wiki/Activity_stream

In addition, a lot of terminology and technical stuff (data model in particular) is derived from the Activity Streams specification so it can be a useful resource as well:

http://activitystrea.ms/

## OK, but does OSM really need this?

As it says in the project description - this is just an effort to make OpenStreetMap a little bit more social.

One can argue that OSM is fundamentally a social project, not a technical one. Implementing the activity stream functionality is an attempt to expand the social aspect of OSM (or osm.org specifically).

Some examples how activity stream could be used:

* Broadcasting locally relevant information like mapping parties, meetings, quick GPS trips etc.
* Tracking mapping activity in specific areas - similar to the existing "nearby changesets" functionality but more user-friendly (bot edits filtered out, human-readable descriptions of changesets etc).
* Tracking activity of friends - mapping, diary entries, perhaps status updates.

Note that this project (OSM Activity Server) is not supposed to provide the above functionality. This project is meant to implement a stable and scalable platform. Various activities (such as those mentioned above) can then be published to the Activity Server (see also "What does it do?" section below).

## Why a separate server?

The idea is to have a server for activities in order to implement the functionality without putting additional load on the main application and database servers in the OSM infrastructure.

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
