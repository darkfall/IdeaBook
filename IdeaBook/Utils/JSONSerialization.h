//
//  JSONSerialization.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Idea;
@class IdeaUser;
@class IdeaComment;
@class IdeaCategory;

@interface JSONSerialization : NSObject

+ (Idea*)deserializeIdea:(NSDictionary*)dict;
+ (NSDictionary*)serializeIdea:(Idea*)idea;

+ (IdeaComment*)deserializeComment:(NSDictionary*)dict;
+ (IdeaUser*)deserializeUser:(NSDictionary*)dict;

@end
