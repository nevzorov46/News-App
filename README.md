# News-App


This app - is the test task for iOS starting position in the "FINAM".
The app - is the list of the top news of the USA:
![Simulator Screen Shot - iPhone 12 Pro Max - 2021-08-29 at 19 38 15](https://user-images.githubusercontent.com/54248784/131258258-8faa7b00-e192-4d75-9382-3911d0bb86e2.png)

User can scroll down through the current top news. Also, user can pull to refresh to update timeline.
When the news is tapped, a new application window with details opens: 

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-08-29 at 19 36 03](https://user-images.githubusercontent.com/54248784/131258260-10b1cf0c-ff81-4d0d-a0e1-5815980b0d15.png)

The API gives only the beginning of an article, so the details window has a button that opens the full text in Safari.

## Requirements

- Xcode 26
- iOS 17+

Open `News-App.xcodeproj` and run. The only dependency, SDWebImage, comes through Swift Package Manager.

