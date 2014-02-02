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
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GeoLocationManager sharedInstance] startUpdate];
    
    [ServerAPI registerNewUser:[UserManager getCurrentUser] success:^{
        NSLog(@"[ServerAPI] Registration succeed");
    } fail:^{
        // failed ? maybe not internet connection ?
        NSLog(@"[ServerAPI] Registration failed");
    }];
   // [TestServerAPI run];
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[IdeaManager sharedInstance] saveDataToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[IdeaManager sharedInstance] saveDataToDisk];
}

@end
