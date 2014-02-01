//
//  IdeaUser.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdeaUser : NSObject

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* lastUpdateTime;
@property (strong, nonatomic) NSString* avatarPath;

@property (strong, nonatomic) NSNumber* latitude;
@property (strong, nonatomic) NSNumber* longitude;

@end
