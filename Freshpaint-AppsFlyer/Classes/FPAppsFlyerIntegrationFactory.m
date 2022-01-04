//
//  FPAppsFlyerIntegrationFactory.m
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "FPAppsFlyerIntegrationFactory.h"


@implementation FPAppsFlyerIntegrationFactory : NSObject

+ (instancetype)instance
{
    static dispatch_once_t once;
    static FPAppsFlyerIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithLaunchDelegate:nil andDLDelegate:nil];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithLaunchDelegate:(id<FPAppsFlyerLibDelegate>) delegate andDLDelegate:(id<FPAppsFlyerDeepLinkDelegate>) DLDelegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.DLDelegate = DLDelegate;
    }
    return self;
}


+ (instancetype)createWithLaunchDelegate:(id<FPAppsFlyerLibDelegate>) delegate
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate: nil];
}

+ (instancetype)createWithLaunchDelegate:(id<FPAppsFlyerLibDelegate>) delegate andDeepLinkDelegate:(id<FPAppsFlyerDeepLinkDelegate>)DLdelegate
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate:DLdelegate];
}

- (id<FPIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(FPAnalytics *)analytics
{
    return [[FPAppsFlyerIntegration alloc] initWithSettings:settings withAnalytics:analytics
                                            andDelegate:self.delegate andDeepLinkDelegate:self.DLDelegate];
}

- (NSString *)key
{
    return @"AppsFlyer";
}
@end
