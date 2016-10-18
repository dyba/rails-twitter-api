# Rails Twitter API

## Setup

Here is the list of environment variables you'll need to set to get this application to work:

<table>
  <tr>
    <td>Environment Variable</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>TWITTER_CONSUMER_SECRET</td>
    <td>The consumer secret needed to access Twitter's API</td>
  </tr>
  <tr>
    <td>TWITTER_CONSUMER_KEY</td>
    <td>The consumer key needed to access Twitter's API</td>
  </tr>
</table>

## System Requirements

<table>
  <tr>
    <td>Ruby version</td>
    <td>2.3.0</td>
  </tr>
  <tr>
    <td>MongoDB</td>
    <td>3.2.10</td>
  </tr>
</table>

## Design

* MongoDB for caching tweets of a given user. Requests made within the ```expires\_at``` interval would receive cached statuses.
Requests made past this interval would trigger a new Twitter API call to retrieve the user timeline and update the cached statuses.
* Lightweight Twitter client in ```lib/```. I chose to roll out my own client for a few reasons:
  * It allowed me to showcase unit testing a library
  * Working with larger rails apps, I've noticed the incredible number of gems that are installed can lead to being stuck on
    certain dependencies because libraries are not actively maintained. This can prevent the app from taking advantage of newer Rails
    features. Having many dependencies increases the time for auditing gems for security vulnerabilities.
  * It allowed me to only use what I needed. I briefly considered using the twitter gem which would have accelerated my development,
    but it would have also given me a lot of functionality I wasn't going to use.
* Minitest instead of RSpec. I prefer a lightweight tool for testing. I've been burned in the past where I unknowingly renamed a
  variable to one that was used internally in RSpec. Debugging this was awful.

## Running Tests

To run the tests:

```
rake test
```
