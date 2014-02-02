//
//  AppDelegate.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "AppDelegate.h"

#import "Tests/TestServerAPI.h"
#import "Utils/IdeaManager.h"
#import "Utils/ServerAPI.h"
#import "Utils/UserManager.h"
#import "Utils/AlertHelper.h"

#import "NZAlertView.h"

#import "Reachability/Reachability.h"


@interface AppDelegate () {
    Reachability* _internetReachbility;
}

@end

@implementation AppDelegate

- (void)testInternet {
    // just test google connection, if google is down, then the Internet maybe not so good
   _internetReachbility = [Reachability reachabilityWithHostname:@"www.google.com"];
        
   _internetReachbility.reachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    _internetReachbility.unreachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AlertHelper showNZAlert:@"Info" message:@"No Internet connection detected. Some features may not working." style:NZAlertStyleInfo duration:2.0f];
        });
    };
    
    [_internetReachbility startNotifier];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if([UserManager getEnableLocationService])
        [[GeoLocationManager sharedInstance] startUpdate];
    
    [ServerAPI registerNewUser:[UserManager getCurrentUser] success:^{
        NSLog(@"[ServerAPI] Registration succeed");
    } fail:^{
        // failed ? maybe not internet connection ?
        NSLog(@"[ServerAPI] Registration failed");
    }];
    
    [self testInternet];
   // [TestServerAPI run];
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[IdeaManager sharedInstance] saveDataToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[IdeaManager sharedInstance] saveDataToDisk];
}

@end
