OpenStreetMap Activity Server
=============================

## What is this?

This is an attempt to make OpenStreetMap more like Facebook.

## That's great! Wait... what?

Well, not *exactly* like Facebook, just a little bit more "social".

Ever wanted to know what's going on in your area - who is mapping what, who recently joined and maybe needs a helping
hand? Ever wanted to let people know that you are going on a bicycle trip on Saturday to do some mapping? And do it
without broadcasting it on mailing lists and/or IRC and/or forums and/or your blog?

Idea for the activity server is to have a single place that will aggregate information on OSM-related activities.

Activity server will expose this information in a standard way (JSON, RSS/ATOM feeds) so that applications and users can
consume it any way they want.

Activity server is meant to be extensible by accepting activities from *activity publishers*. There is a simple API for
publishing an activity - application developers can use it to integrate their content into activity streams.

## What's an activity (stream) anyway?

According to Wikipedia: *"An activity stream is a list of recent activities performed by an individual, typically on a single website."*

In its simplest form, an activity is a sentence in the following form:

<actor> <verb> <object> [<target>]

So for example:

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

# Technical stuff

## Overview

The server is a simple Ruby on Rails web application.

Data model is derived directly from the JSON Activity Streams 1.0 and Audience Targeting for JSON Activity Streams specifications:

http://activitystrea.ms/specs/json/1.0/

http://activitystrea.ms/specs/json/targeting/1.0/

Activities are stored in a Postgres/PostGIS database in a simplified schema (not all attributes from above specs are
stored - they will be added as needed in the future).

## API

See API file.
