//
//  FPAppsFlyerIntegration.h
//  AppsFlyerFreshpaintiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FPAnalytics.h"
#import "FPAnalyticsUtils.h"

#import <AppsFlyerLib/AppsFlyerLib.h>


@protocol FPAppsFlyerLibDelegate <AppsFlyerLibDelegate>

@end

@protocol FPAppsFlyerDeepLinkDelegate<AppsFlyerDeepLinkDelegate>


@end

@interface FPAppsFlyerIntegration : NSObject <FPIntegration, AppsFlyerLibDelegate, AppsFlyerDeepLinkDelegate>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) AppsFlyerLib *appsflyer;
@property (nonatomic, strong) FPAnalytics *analytics;
@property (weak, nonatomic) id<FPAppsFlyerLibDelegate> fpDelegate;
@property (weak, nonatomic) id<AppsFlyerDeepLinkDelegate> fpDLDelegate;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(FPAnalytics *) analytics;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(FPAnalytics *)analytics
                andDelegate:(id<AppsFlyerLibDelegate>) delegate;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(FPAnalytics *)analytics
                andDelegate:(id<AppsFlyerLibDelegate>) delegate
             andDeepLinkDelegate:(id<AppsFlyerDeepLinkDelegate>) DLDelegate;




- (void) start;
@end

