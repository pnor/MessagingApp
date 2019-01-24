# MessagingApp
Small iMessage App Extension project for iOS coded programmatically without any storyboards

### Features
Has a compact and expanded menu allowing you to choose from a variety of options:
<img src="https://github.com/pnor/MessagingApp/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202019-01-23%20at%2023.13.28.png" height="900">
<img src="https://github.com/pnor/MessagingApp/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202019-01-23%20at%2023.14.17.png" height="900">

Start an interactive iMessage Session:
<img src="https://github.com/pnor/MessagingApp/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202019-01-23%20at%2023.14.33.png" height="900">
<img src="https://github.com/pnor/MessagingApp/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202019-01-23%20at%2023.14.41.png" height="900">

### Notes
Still quite buggy, especially with switching presentation styles and sending sessions.

### Takeaways
To get it running without storyboards:
- Change the NSExtensionPrincipalClass to the MessagesViewController in the info.plist 
- If coding in Swift, add `@objc (MessagesViewController)` to the top of MessagesViewController class (but below imports).
  * Note that protocols that MessagesViewController extends also have to be marked with `@objc`

### Credits
- Wii Fit Trainer's Image
- Useful Articles:
  * NSExtensionPrincipalClass: https://agilewarrior.wordpress.com/2016/12/14/how-to-create-imessage-app-extension-without-storyboard/
  
