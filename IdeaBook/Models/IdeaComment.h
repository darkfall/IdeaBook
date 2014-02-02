//
//  IdeaComment.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IdeaUser;
@class Idea;

@interface IdeaComment : NSObject

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* uuid;

@property (strong, nonatomic) NSString* user_name;
@property (strong, nonatomic) NSString* user_uuid;

@end
