//
//  UserManager.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IdeaUser;

@interface UserManager : NSObject

+ (IdeaUser*)getCurrentUser;
+ (void)saveCurrentUser;
+ (bool)userExists;

+ (void)setEnableLocationService:(bool)flag;
+ (bool)getEnableLocationService;

+ (void)setIdeaDropInterval:(float)interval;
+ (float)getIdeaDropInterval;

+ (bool)isFirstTimeShare;

@end
