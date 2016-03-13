# Project 4 - *Tweety*

**Tweety** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **11** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] Retweeting and favoriting should increment the retweet and favorite count.

The following **optional** features are implemented:

- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] User can pull to refresh.

The following **additional** features are implemented:

- [x] Obfuscating twitter api keys using another plist file. To run this app see [instructions](https://github.com/venegu/tweety#installation) below.
- [x] Adding gradient in the log in page using layers.
- [x] Adding drop shadow across all instances of navigation bars in the code base by adding an extension the the `UINavigationBar`.
- [x] Showing network errors with an animated view (I learned this from another student :D) and allowing the user to retry the network ... currently only supports timeline... will soon support other network requests.
- [x] Customized user interfaces with neat icons :).
- [ ] Refresh animation (on the way in another branch).

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Hiding API keys is probably an important thing to talk about...

2. Different ways of doing requests and the best way to do them.

## Video Walkthrough

Here's a walkthrough of implemented user stories:


<img src='https://github.com/venegu/tweety/raw/master/tweety.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />              <img src='https://github.com/venegu/tweety/raw/master/tweety2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

I had a WiFi problem at the end... Didn't really want to redo this walkthrough again though :panda_face:. __NOTE__: Second GIF shows added in support for displaying network errors... haha @_@.

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Installation

To run this app you will need to provide your own [Twitter key and secret](https://apps.twitter.com) and create a with these values `key.plist` file.

In the `key.plist` file you will need to add your consumer key and consumer secret as the following keys respectively: `consumerKey` and `consumerSecret`. Please make sure that the type of each entry is a *String*. See the below example.

The function that handles the secret values is called `retrieveKeys()` and can be found in the `AppDelegate.swift`.

## Notes

Describe any challenges encountered while building the app.

## Resources

### Hiding API Keys
   - http://stackoverflow.com/questions/30705214/call-app-delegate-method-from-view-controller

## Credits

   - Twitter Icons - Courtesy of the [Twitter Brand Assets](https://about.twitter.com/company/brand-assets) and a student at CCSF
   - Compose Icon - [Gregor Črešnar](https://thenounproject.com/search/?q=compose&i=256159)
   - Cancel Icon - [Shawn Wong](https://thenounproject.com/search/?q=x&i=114046)
   - Network Alert Icon - [Ugur Akdemir](https://thenounproject.com/search/?q=wifi&i=26774)
   - Magnifying Glass Icon - [Eugen Belyakoff](https://thenounproject.com/search/?q=magnifying+glass&i=38681)

Many thanks!

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


# Project 5 - *Tweety*

Time spent: **13** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] Profile page:
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline: Tapping on a user image should bring up that user's profile page
- [x] Compose Page: User can compose a new tweet by tapping on a compose button.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should resize the header image. NOTE: I didn't get the blur done :(
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [x] Displaying user tweets in the profile page.
- [x] Allows for showing images and properly changes the constraints if the post has no image.
- [x] Properly changes constraints for retweeted tweets.
- [x] "Prettifies" the time in the Tweet model.
- [x] Resizes profile image view under profile banner as the user scrolls using Core Animation translation and scale functions and hides it under the banner using Z position.
- [x] Resizes profile banner as the user scrolls using Core Animation translation and scale functions.
- [x] Showing number of tweets in the "navigation bar" by using the Core Animation.
- [x] Fetches higher res profile image in the User model (had intentions of fading in images).


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.
2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/venegu/tweety/raw/master/tweety3.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />       <img src='https://github.com/venegu/tweety/raw/master/tweety4.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

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
