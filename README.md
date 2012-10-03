OpenStreetMap Activity Server
=============================

Making OpenStreetMap a little bit more social ;-)

## What is this?

OpenStreetMap Activity Server is a simple server that is a central component of the activity stream implementation for the OpenStreetMap project.

## Umm, right... but what is this "activity stream" you speak of?

According to Wikipedia:

*"An activity stream is a list of recent activities performed by an individual, typically on a single website."*

See http://en.wikipedia.org/wiki/Activity_stream

In addition, a lot of terminology and technical stuff (data model in particular) is derived from the Activity Streams specification so it can be a useful resource as well:

http://activitystrea.ms/

For an OpenStreetMap user this would mean having an activity stream on their user page - somewhat similar to popular social networks only without all the noise like "I just ate a sandwich" :-)

So for example, you would see on your user page:

* John Doe added a bridge and modified two highways in London.
* Jane Doe says "We are having a mapping party on Friday! Let's meet up at 7PM near Youknowhere"
* George Costanza posted a diary entry "How to avoid shrinkage"

## OK, but does OSM really need this?

As it says in the project description - this is just an effort to make OpenStreetMap a little bit more social.

One can argue that OSM is fundamentally a social project, not a technical one. Implementing the activity stream functionality is an attempt to expand the social aspect of OSM (or osm.org specifically).

Some examples how activity stream could be used:

* Broadcasting locally relevant information like mapping parties, meetings, quick GPS trips etc.
* Tracking mapping activity in specific areas - similar to the existing "nearby changesets" functionality but more user-friendly (bot edits filtered out, human-readable descriptions of changesets etc).
* Tracking activity of friends - mapping, diary entries, perhaps status updates.

Note that this project (OSM Activity Server) is not supposed to provide the above functionality. This project is meant to implement a stable and scalable platform. Various activities (such as those mentioned above) can then be published to the Activity Server (see also "What does it do?" section below).

At the end of the day it's all about making mapping more fun and providing tools for interacting with other mappers.

## Why a separate server?

The idea is to have a server for activities in order to implement the functionality without putting additional load on the main application and database servers in the OSM infrastructure.

## What does it do?

It has several responsibilities:

* Accept, process and store new activities.
* Serve activity streams (a collection of activities).

# Technical stuff

## Overview

The server is a simple Ruby on Rails web application.

Data model is derived directly from the JSON Activity Streams 1.0 and Audience Targeting for JSON Activity Streams specifications:

http://activitystrea.ms/specs/json/1.0/
http://activitystrea.ms/specs/json/targeting/1.0/

Activities are stored in a Postgres/PostGIS database in a simplified schema (not all attributes from above specs are
stored - they will be added as needed in the future).

## API

### Creating new activity

URL: /activities
Request: POST with request parameter named "json"

Parameter "json" is expected to contain a JSON document representing an activity. Format is described in the specification:

http://activitystrea.ms/specs/json/1.0/#activity

### Retrieving an activity stream

TBD
