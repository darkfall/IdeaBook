//
//  UserManager.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "UserManager.h"
#import "NSUserDefaults+DefaultValue.h"
#import "../Models/IdeaUser.h"

#define kUserUUIDKey @"UserUUID"
#define kUserNameKey @"UserName"
#define kUserAvatarPathKey @"UserAvatar"
#define kUserLongitudeKey @"UserLongitude"
#define kUserLatitudeKey @"UserLatitude"

@implementation UserManager

static IdeaUser* user = nil;

+ (NSString*)createUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return newUUID;
}

+ (IdeaUser*)getCurrentUser {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* uuid = [defaults stringForKey:kUserUUIDKey];
    
    if(!uuid) {
        uuid = [UserManager createUUID];
        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:kUserUUIDKey];
    }
    
    if(user == nil) {
        user = [[IdeaUser alloc] init];
        user.uuid = uuid;
        
        user.name = [defaults stringForKey:kUserNameKey defaultValue:@"Anonymous"];
        user.avatarPath = [defaults stringForKey:kUserAvatarPathKey defaultValue:@""];
        
        user.longitude = [NSNumber numberWithDouble:[defaults doubleForKey:kUserLongitudeKey]];
        user.latitude = [NSNumber numberWithDouble:[defaults doubleForKey:kUserLatitudeKey]];
    }
    
    return user;
}


+ (void)saveCurrentUser {
    if(user) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:user.uuid forKey:kUserUUIDKey];
        [defaults setValue:user.name forKey:kUserNameKey];
        [defaults setValue:user.avatarPath forKey:kUserAvatarPathKey];
        [defaults setValue:user.longitude forKey:kUserLongitudeKey];
        [defaults setValue:user.latitude forKey:kUserLatitudeKey];
    }
}

+ (bool)userExists {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserUUIDKey] != nil;
}

@end
