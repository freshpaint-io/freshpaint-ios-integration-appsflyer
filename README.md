# AppsFlyer integration for Freshpaint.

----------

🛠 In order for us to provide optimal support, we would kindly ask you to submit any issues to support@freshpaint.io

----------

## Table of content

- [Installation](#installation)
- [Usage](#usage)
  - [Objective-C](#usage-obj-c)
  - [Swift](#usage-swift)
- [Get Conversion Data](#getconversiondata)
  - [Objective-C](#gcd-obj-c)
  - [Swift](#gcd-swift)
- [Unified Deep linking](#DDL)
    - [Swift](#ddl-swift)
- [Install Attributed event](#install_attributed)
- [Additional AppsFlyer SDK setup](#additional_setup)
- [Examples](#examples)


## <a id="installation">Installation

### Cocoapods

To install the Freshpaint-AppsFlyer integration:

1. Simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

**Production** version:
```ruby
pod 'Freshpaint-AppsFlyer', :git => 'https://github.com/freshpaint-io/freshpaint-ios-integration-appsflyer.git', :tag => '0.1.0'
```

2. Run `pod install` in the project directory


## <a id="usage"> Usage

### <a id="usage-obj-c"> Usage - Objective-C

Open `AppDelegate.h` and add:

```
#import "FPAppsFlyerIntegrationFactory.h"
```

In `AppDelegate.m` ➜ `didFinishLaunchingWithOptions`:

```objective-c

    // For ApsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;

    // Getting user consent dialog. Please read https://support.appsflyer.com//hc/en-us/articles/207032066#integration-35-support-apptrackingtransparency-att
    if (@available(iOS 14, *)) {
        [[AppsFlyerLib shared] waitForAdvertisingIdentifierWithTimeoutInterval:60];
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            //....
        }];
    }
    /*
     Based on your needs you can either pass a delegate to process deferred
     and direct deeplinking callbacks or disregard them.
     If you choose to use the delegate, see extension to this class below
     */
    FPAppsFlyerIntegrationFactory* factoryNoDelegate = [FPAppsFlyerIntegrationFactory instance];
//    FPAppsFlyerIntegrationFactory* factoryWithDelegate = [FPAppsFlyerIntegrationFactory createWithLaunchDelegate:self];

    FPAnalyticsConfiguration *config = [FPAnalyticsConfiguration configurationWithWriteKey:@"WYsuyFINOKZuQyQAGn5JQoCgIdhOI146"];
    [config use:factoryNoDelegate];
    configuration.defaultSettings = @{
        @"integrations": @{
                @"AppsFlyer": @{
                        @"appsFlyerDevKey": @"<dev key>",
                        @"trackAttributionData": @YES,
                        @"appleAppID": @"<app ID>"
                },
  
//    [config use:factoryWithDelegate];  // use this if you want to get conversion data in the app. Read more in the integration guide
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    config.trackAttributionData = YES;            //OPTIONAL
    [FPAnalytics debug:YES];                     //OPTIONAL
    [FPAnalytics setupWithConfiguration:config];
```

AppsFlyer integration responds to ```identify``` call.  To read more about it, visit [Freshpaint identify method documentation](https://documentation.freshpaint.io/developer-docs/freshpaint-ios-sdk-reference#identify).

## <a id="getconversiondata"> Get Conversion Data

  In order for Conversion Data to be sent to Freshpaint, make sure you have enabled "Track Attribution Data" and specified App ID in AppsFlyer destination settings.

### <a id="gcd-obj-c"> Objective-C


  In order to get Conversion Data you need to:

  1. Add `FPAppsFlyerLibDelegate` protocol to your AppDelegate.h (or other) class
```
#import <UIKit/UIKit.h>
#import "FPAppsFlyerIntegrationFactory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FPAppsFlyerLibDelegate>
```
  2. Pass AppDelegate (or other) class when configuring Freshpaint Analytics with AppsFlyer. Change line `[config use:[FPAppsFlyerIntegrationFactory instance]];` to `[config use:[FPAppsFlyerIntegrationFactory createWithLaunchDelegate:self]];`
  3. In the class passed to the method above (AppDelegate.m by default) implement methods of the `FPAppsFlyerLibDelegate` protocol. See sample code below:

```
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)onConversionDataSuccess:(NSDictionary*) installData {
    BOOL first_launch_flag = [[installData objectForKey:@"is_first_launch"] boolValue];
    NSString *status = [installData objectForKey:@"af_status"];

    if(first_launch_flag) {
        if ([status isEqualToString:@"Non-organic"]){
            NSString *sourceID = [installData objectForKey:@"media_source"];
            NSString *campaign = [installData objectForKey:@"campaign"];
            NSLog(@"This is a non-organic install. Media source: %@ Campaign: %@", sourceID, campaign);
        } else {
            NSLog(@"This is an organic install");
        }
    } else {
        NSLog(@"Not first launch");
    }
};

/**
 Any errors that occurred during the conversion request.
 */
-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@", [error description]);
};

/**
 `attributionData` contains information about OneLink, deeplink.
 */
- (void)onAppOpenAttribution:(NSDictionary *)attributionData{
    NSLog(@"onAppOpenAttribution");
    for(id key in attributionData){
        NSLog(@"onAppOpenAttribution: key=%@ value=%@", key, [attributionData objectForKey:key]);
    }
};

/**
 Any errors that occurred during the attribution request.
 */
- (void)onAppOpenAttributionFailure:(NSError *)error{
    NSLog(@"%@", [error description]);
};

// Rest of your AppDelegate code
```


### <a id="gcd-swift"> Swift

  In order to get Conversion Data you need to:

  1. Add `FPAppsFlyerLibDelegate` protocol to your AppDelegate (or other) class
  2. Pass AppDelegate (or other) class when configuring Freshpaint Analytics with AppsFlyer. If you use sample code from above, change line `config.use(factoryNoDelegate)` to `config.use(factoryWithDelegate)`
  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:

  ```
  class AppDelegate: UIResponder, UIApplicationDelegate, FPAppsFlyerLibDelegate {

    var window: UIWindow?

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        guard let first_launch_flag = conversionInfo["is_first_launch"] as? Int else {
            return
        }

        guard let status = conversionInfo["af_status"] as? String else {
            return
        }

        if(first_launch_flag == 1) {
            if(status == "Non-organic") {
                if let media_source = conversionInfo["media_source"] , let campaign = conversionInfo["campaign"]{
                    print("This is a Non-Organic install. Media source: \(media_source) Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
        } else {
            print("Not First Launch")
        }
    }

    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("Deep Link Data goes here:")
        if let data = attributionData{
          print("\(data)")
        }
    }

   func onConversionDataFail(_ error: Error) {
        }

    func onAppOpenAttributionFailure(_ error: Error?) {
    }
    //rest of you AppDelegate code
  }
  ```

## <a id="DDL"> Unified Deep linking
### <a id="ddl-swift"> Swift
In order to use Unified Deep linking you need to:

  1. Add `FPAppsFlyerDeepLinkDelegate` protocol to your AppDelegate (or other) class
  2. Pass AppDelegate (or other) class when configuring Freshpaint Analytics with AppsFlyer. From the sample code above, change  factoryWithDelegate to :
  ```
  let factoryWithDelegate: FPAppsFlyerIntegrationFactory = FPAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self)
  ```

  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:

```
extension AppDelegate: FPAppsFlyerDeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        print(result)
    }
}

```

## <a id="install_attributed"> Install Attributed event

If you are working with networks that don't allow passing user level data to 3rd parties, you will need to apply code to filter out these networks before calling
```
// [self.analytics track:@"Install Attributed" properties:[properties copy]];
```

## <a id="additional_setup"> Additional AppsFlyer SDK setup

```objective-c
@import AppsFlyerLib;

...
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(integrationDidStart:) name:FPAnalyticsIntegrationDidStart object:nil];
    ...
}

...

- (void)integrationDidStart:(nonnull NSNotification *)notification {
    NSString *integration = notification.object;
    if ([integration isEqualToString:@"AppsFlyer"]) {
        /// Additional AppsFlyer SDK setup goes below
        /// All setup is optional
        /// To set Apple App ID and AppsFlyer Dev Key use Freshpaint dashboard
        /// ...
        /// Enable ESP support for specific URLs
        [[AppsFlyerLib shared] setResolveDeepLinkURLs:@[@"afsdktests.com"]];
        /// Disable printing SDK messages to the console log
        [[AppsFlyerLib shared]  setIsDebug:NO];
        /// `OneLink ID` from OneLink configuration
        [[AppsFlyerLib shared]  setAppInviteOneLink:@"one_link_id"];
    }
}
```

## <a id="examples"> Examples

This project has an [example](https://github.com/freshpaint-io/freshpaint-ios-integration-appsflyer/tree/main/Example) for objective-C. To give it a try, clone this repo and from each example first run `pod install` to install project dependancies.
