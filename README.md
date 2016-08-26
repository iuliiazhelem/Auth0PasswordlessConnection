# Auth0PasswordlessConnection

This sample exposes how to create email passwordless connection with code and with magic link.

With the e-mail connection, the user is requested to enter their e-mail address. Auth0 then sends an email to that address containing a one-time code or a magic link.

## Step 1: Configure email passwordless connection
You need to open Auth0 Dashboard -> Connections -> Passwordless -> Email and configure email connection as described [here](https://auth0.com/docs/connections/passwordless/email). 

## Step 2: Configure Mobile Settings
In the Auth0 Dashboard: go to your client settings and add your Apple TeamId and bundle identifier in the Mobile Settings Section. 
![Mobile Settings](/media/image1.png)

## Step 3: Add Associated Domains to your application
You need to add Associated Domains entitlement to your app. You can do this by opening the project in Xcode, go to your app's target and select Capabilities tab. Then enable Associated Domains and add your auth0 domain using the following format applinks:<your_auth0_domain>


## Step 4: Add passwordless connection to your application
For this you need to add the following to your `Podfile`:
```
pod 'Lock', '~> 1.26'
pod 'Lock/Email'
```

### Important Snippets
#### Handle iOS callback
In your AppDelegate you need to handle iOS callback when the app opens the magic link by adding the following method and calling Lock like
```swift
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    return A0Lock.sharedLock().continueUserActivity(userActivity, restorationHandler: restorationHandler)
  }
```

#### Authentication with email code
```Swift
  let lock = A0Lock.sharedLock()
  let controller = lock.newEmailViewController()
  controller.useMagicLink = false
  controller.closable = true
  controller.onAuthenticationBlock = {(profile: A0UserProfile!, token: A0Token!) -> () in
    print("profile : \(profile)")
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  lock.presentEmailController(controller, fromController: self)
```
#### Authentication with email magic link
```Swift
  let lock = A0Lock.sharedLock()
  let controller = lock.newEmailViewController()
  controller.useMagicLink = true
  controller.closable = true
  controller.onAuthenticationBlock = {(profile: A0UserProfile!, token: A0Token!) -> () in
    print("profile : \(profile)")
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  lock.presentEmailController(controller, fromController: self)
```


Please make sure that you change some keys in `Info.plist` with your Auth0 data from [Auth0 Dashboard](https://manage.auth0.com/#/applications):
- Auth0ClientId
- Auth0Domain
- CFBundleURLSchemes
```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a0{CLIENT_ID}</string>
</array>
```
For more information about email passwordless please check the following links:
- [Using passwordless](https://auth0.com/docs/connections/passwordless/ios)
- [iOS email](https://auth0.com/docs/connections/passwordless/ios-email-objc)
