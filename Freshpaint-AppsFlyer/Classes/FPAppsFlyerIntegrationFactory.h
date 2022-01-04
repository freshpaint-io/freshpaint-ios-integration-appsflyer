//
//  FPAppsFlyerIntegrationFactory.h
//  AppsFlyerFreshpaintiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FreshpaintSDK/FPIntegrationFactory.h>
#import "FPAppsFlyerIntegration.h"


@interface FPAppsFlyerIntegrationFactory : NSObject <FPIntegrationFactory>

+ (instancetype)instance;
+ (instancetype)createWithLaunchDelegate:(id<FPAppsFlyerLibDelegate>) delegate;

+ (instancetype)createWithLaunchDelegate:(id<FPAppsFlyerLibDelegate>) delegate andDeepLinkDelegate:(id<FPAppsFlyerDeepLinkDelegate>) DLdelegate;

@property (weak, nonatomic) id<FPAppsFlyerLibDelegate> delegate;
@property (weak, nonatomic) id<FPAppsFlyerDeepLinkDelegate> DLDelegate;
@end
