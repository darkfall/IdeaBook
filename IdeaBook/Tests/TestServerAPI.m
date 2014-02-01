//
//  TestServerAPI.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "TestServerAPI.h"

#import "../Utils/ServerAPI.h"
#import "../Utils/GeoLocationManager.h"
#import "../Utils/UserManager.h"

#import "../Models/IdeaUser.h"

@implementation TestServerAPI

+ (void)run {
    IdeaUser* user = [UserManager getCurrentUser];
    
    [ServerAPI registerNewUser:user success:^() {
        NSLog(@"[TestServerAPI] registerNewUser: succeed");
        
        [ServerAPI getSharedIdeas:user success:^(NSArray* ideas) {
            
            NSLog(@"[TestServerAPI] getSharedIdeas: %d", [ideas count]);
            
        } fail:^() {
            
            NSLog(@"[TestServerAPI] getSharedIdeas: failed");
            
        }];
        
    } fail:^() {
        NSLog(@"[TestServerAPI] registerNewUser: failed");
        
    }];
    
    [ServerAPI getIdeasNearby:0 longitude:0 success:^(NSArray* ideas) {
        
        NSLog(@"[TestServerAPI] getIdeasNearby: %d", [ideas count]);
        
    } fail:^() {
        
        NSLog(@"[TestServerAPI] getIdeasNearby: failed");
        
    }];
}

@end
