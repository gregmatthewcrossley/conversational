# Conversational
### A talk radio program about where you are right now.

#### Manual Testing
To test the two remark generator services, in the Rails console, run:
```
reload!; remark = Remarks::TextGeneratorService.call("Toronto, Ontario"); Remarks::AudioGeneratorService.call(remark)
```


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Rough Notes
- Make a "conversation" resource.
- Get a simple audio stream working on the "show conversation" page. Use ActionCable.
- Make a "position" (include lat, long, alt, bearing, speed timestamps) - belong to conversation
- Build a worker that accepts a conversation object and generates a queue of sound files to stream to the client.
