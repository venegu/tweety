# Project 4 - *Tweety*

**Tweety** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [ ] User can view last 20 tweets from their home timeline
- [ ] The current signed in user will be persisted across restarts
- [ ] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [ ] Retweeting and favoriting should increment the retweet and favorite count.

The following **optional** features are implemented:

- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] User can pull to refresh.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.
2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<!--<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />-->

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Installation

To run this app you will need to provide your own [Twitter key and secret](https://apps.twitter.com) and create you own `key.plist` file.

In the `key.plist` file you will need to add your consumer key and consumer secret as the following keys respectively: `consumerKey` and `consumerSecret`. Please make sure that the type of each entry is a *String*. See the below example.

The function that handles the secret values is called `retrieveKeys()` and can be found in the `AppDelegate.swift`.

## Notes

Describe any challenges encountered while building the app.

## Resources

### Hiding API Keys
   - http://stackoverflow.com/questions/30705214/call-app-delegate-method-from-view-controller

## License

    Copyright [2016] [Lisa Maldonado]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
