# README

* Ruby version: `ruby 2.6.3p62 [x86_64-darwin18]`

* System dependencies: 
    - `Bundler version 1.17.2`
    - `SQLite 3.24.0 2018-06-04 14:10:15`

* Configuration: `bundle install`

* How to run the test suite: `rake`

# Implementation Notes

One of the requirements is "must be a valid domain name" (or subdomain part for the NAME attribute). That turns out to be really, really hard to do well. I guess I know too much about DNS standards. So without further clarification on project constraints, I'd rather be totally wrong than partially so. The only constraint is that it can't be empty. The special `@` means very little in this context, so there's special code to handle that either (`*` was not mentioned, so ...).

# Exercise: DNS Record Manager API

For this exercise, we are going to be implementing a RESTful API for managing DNS records, the kind of service one could imagine being used behind the scenes at a DNS hosting service.

A client of this API should be able to create and delete zones, view and manage all of the records within a zone.

Expect this exercise to take roughly *2-3 hours*.

## General Requirements

Much of the implementation will be left to you. However, the following requirements should be observed:

- Built using Ruby or Go
- SQLite as data store
- RESTful endpoints
- JSON responses
- Appropriate test coverage

## Application Requirements

The API will expose two main resource endpoints: *Zone* and *Record*.

## Zone

- Has a name, which must be a valid domain name.
- Each Zone can contain multiple records.

## Record

A Record will expose the following information:

- `Name`, `Record Type`, `Record Data`, `TTL`
 
The data must have the following constraints:

### Name

- Can be the Zone's root domain, indicated by a value of `@`.
- Can be a subdomain value.

### Record Type

- Will have a value of either A or CNAME

### `A` Record Type

Maps a domain to an IP address. The Record Data must then be a valid IPv4 address.

### `CNAME` Record Type

Are pointers to other domains. The Record Data for a CNAME must then be a valid domain
name.

### TTL

An integer representing the number of seconds a client would cache this record.

## Submission Guidelines

1. Create a private repository
2. Grant Access to: https://github.com/JulienDefrance and https://github.com/BrianSigafoos
3. Inform Erica once complete by sending an email with your repo link to:    erica.schneider@valimail.com
