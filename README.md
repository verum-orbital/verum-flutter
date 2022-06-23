# Verum (Milestone 2)

## Team ID: 5302
## Proposed Level of Achievement: Apollo

## Motivation 

Social media platforms present a skewed perspective of a user’s life. Since users often only share their best moments in life, it can be argued that social media is more of a highlights reel. With the massive amount of people, especially youths, that use social media daily, being constantly exposed to such a distorted and utopian environment can evoke negative feelings arising from comparisons with others.

“Such comparisons may occur frequently with [social media] use because users tend to disproportionately represent positive life developments, portray themselves to be happier than they actually are” (Hanna, 2017). 

According to a study done on about 1,500 teens and adults, Instagram was rated the “worst social media network for mental health and well being” (Macmillan, 2017).

Social media in its current form fails to show how the lives of those around us are just as imperfect as our own, and that they are just as human and fallible as we are. It is incredibly rare to see posts about negative circumstances such as an argument, loss of a job, or feelings of isolation or loneliness.

Such posts would exemplify reality and showcase a non-picture-perfect life. They are relatable rather than comparable. However, they are almost non-existent, and it is hard for users to not compare their worst moments to others’ best. It is difficult for users to remember that others are struggling as well when all they see is happiness.



## Aim 

Our project’s primary goal is to create a social media platform that steers away from the common and generic idea of only capturing and sharing your best moments in life. We believe that this promotes an unhealthy attitude of comparing one’s posts and profiles with others. Therefore, our goal is to create a social media platform that rewards users for their spontaneity and ‘unfiltered-ness’. 

To promote this spontaneity, our application will send out an alert randomly at different points of the day. Everytime an alert is sent, a fifteen minute window is given to capture a moment and share it across the application. This fifteen minute window is what differentiates our social media application from other conventional applications out there. This window that is being given to users adds this element of mystery where one cannot specifically plan out or cater certain periods of time specifically to take pictures. For example, the alert could be sent out early in the morning at 8.00am when you are making breakfast or 4.00pm when you are out with your friends or even 7.00pm on the train after a long day at work. However, seeing this alert should act as a psychological boost to snap out any misery and pick yourself up to look at the camera and take a near-candid picture as nearly every aspect of the picture is unplanned. 

These alerts will be sent out minimally twice a day so users have two chances to take these pictures and at the end of the day they can pick which picture they want on their page.  This act of posting “unplanned moment” pictures would encourage users to embrace their life and reduce this comparison culture.

## User Stories

- Whenever an alert is received, users are given fifteen minutes to capture a video or picture.
- Minimally two alerts will be given per day, so that in the slightest chance when users do not have their phone on them during the first alert, they will still be able to post something when the second alert is received. 
- At the end of the day, the user can choose to post one photo or video from all the memories that they have captured from the day.
- Users will be able to find other friends and family on the application and look at their profile.
- Users will be able to get a snapshot of their favourite celebrity and role models lives. 



## Proposed Features and Timeline

### Web App & Mobile App

We intend to use Flutter and Firebase to develop Verum.

#### Features to be completed by the end of June: 

- User Authentication ✅  
- User Profile ✅
- Upload posts ✅
- View post history ✅
- Push notifications ✅
- Relationship system (e.g. Follow & Unfollow, Friend & Unfriend, etc) ✅
- View other users’ posts ✅


#### Features to be completed by the end of July: 
- Post timing restrictions 
- Gamification/Points system 
- Incentivise users to post regularly & abide by timing constraints
- Allow users to earn “reputation/credibility” that shows how unfiltered their posts are (to what extent they abide by the spirit of the platform) 
- Privacy Settings (private or public account)
- Likes System
- Comment system
- Chat/Messaging

## Current Progress

### User Flow / Design Diagram

<img width="878" alt="Verum User Flow" src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/VerumUserFlow.png">

### Firestore Database Schema

<img width="1012" alt="Firestore DB Schema" src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/FirestoreDBSchema.png">

- In Milestone 2, a design decision was made to reorganise the followers/following data as above. This made it easier and more computationally efficient to retrieve the list of user IDs that the current user is following or is being followed by. The previous schema was such that to find a user's followers, every user ID in the database had to be retrieved.
- The trade-off here is that the follow/unfollow logic must ensure that the appropriate collection for both users' involved are updated. This slightly increases the chance of bugs if we are not careful. The previous schema meant that only one document had to be updated per follow request.
- For reference, the previous schema can be found at [this commit](https://github.com/verum-orbital/verum-flutter/commit/8a69cd92e0245ea5bcc3d90324504154046db20b)

### Login Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/LoginScreen.png" width="200">

- Users are able to login with their registered email and password
- This is done via Firebase Authentication
 
### Sign-up Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/SignupScreen.png" width="200">

- Users are able to register with an email and password
- This is done via Firebase Authentication

### Reusable Profile Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/ProfileSelf.png" width="200">

- Users are able to view their post history in the Profile tab
- This screen is made reusable for UI consistency when viewing other Verum users via the Search functionality (see below)

### Search Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/SearchScreenInactive.png" width="200">

- When the search textfield is inactive, the Search screen currently displays all the posts from the database. In future iterations, this may change to only show posts from accounts that are set to **public**.

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/SearchScreenActive.png" width="200">

- Users are able to search for other users via their usernames

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/ProfileFollow.png" width="200">

- Tapping on the list item will bring them to the corresponding Profile screen.

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/ProfileUnfollow.png" width="200">

- The follow and unfollow button is dynamically shown depending on the current follow status of that user.

### Add Post Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/CreatePostButton.png" width="200">

- Clicking the upload button brings up a dialog that can take the user to his/her device's image gallery or camera.

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/CreatePostScreen.png" width="200">

- Users are able to create a post with a caption using an image from their device's gallery or camera

### User Feed Screen

<img src="https://raw.github.com/verum-orbital/verum-flutter/master/README_assets/FeedScreen.png" width="200">

- Users are able to view posts from followed users. 
- Note: The likes and comments system is currently not implemented in the app. Placeholders were used instead.


### User Testing

- To run Verum on your own system, you must have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your system. 
  - Once installed, you can run `flutter doctor` to determine any other missing requirements for your relevant platform. 
  - Once your environment has been set up, launch a simulator or connect an Android/iOS device. 
  - Clone the repo via git with the URL: https://github.com/verum-orbital/verum-flutter.git
  - Run the following command from the root directory to build and deploy the demo to your device: 
 ```
 flutter run
 ```

- If you have an android device, you may test our app directly by installing the apk file [here](https://drive.google.com/file/d/1kAs3BcBlSxf79rElcdDr1YBiy2Udrbgv/view?usp=sharing)

