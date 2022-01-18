//
//  FPAppDelegate.m
//  Freshpaint-AppsFlyer
//
//  Created by jmtaber129 on 01/04/2022.
//  Copyright (c) 2022 jmtaber129. All rights reserved.
//

#import "FPAppDelegate.h"
#import <Freshpaint/FPAnalytics.h>
#import <Freshpaint-AppsFlyer/FPAppsFlyerIntegrationFactory.h>

NSString *const FPMENT_WRITE_KEY = @"5bd86532-4cc1-4b18-8392-880be8eb0e3d";

@implementation FPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // For ApsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;
    FPAppsFlyerIntegrationFactory* factoryNoDelegate = [FPAppsFlyerIntegrationFactory instance];

    [FPAnalytics debug:YES];
    FPAnalyticsConfiguration *configuration = [FPAnalyticsConfiguration configurationWithWriteKey:FPMENT_WRITE_KEY];
    configuration.trackApplicationLifecycleEvents = YES;
    configuration.flushAt = 1;
    [configuration use:factoryNoDelegate];
    configuration.defaultSettings = @{
        @"integrations": @{
                @"AppsFlyer": @{
                        @"appsFlyerDevKey": @"5pBF6VVurokueZBiqggaEa",
                        @"trackAttributionData": @YES,
                        @"appleAppID": @"id663793798"
                },
                @"Freshpaint.io": @{
                        @"apiKey": FPMENT_WRITE_KEY
                }
        }
    };

    [FPAnalytics setupWithConfiguration:configuration];
    [[FPAnalytics sharedAnalytics] track:@"App Launched"];

    [[FPAnalytics sharedAnalytics] flush];
    NSLog(@"application:didFinishLaunchingWithOptions: %@", launchOptions);
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
