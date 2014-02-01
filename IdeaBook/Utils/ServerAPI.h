//
//  ServerCommunication.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class IdeaUser;
@class Idea;
@class IdeaCategory;
@class IdeaComment;

// SERVER API MAPPING

@interface ServerAPI : NSObject

+ (void)registerNewUser:(const IdeaUser*)user success:(void (^)(void))success fail:(void (^)(void))fail;

+ (void)getIdeasNearby:(double)latitude longitude:(double)longitude success:(void (^)(NSArray*))success fail:(void (^)(void))fail;

+ (void)getSharedIdeas:(const IdeaUser*)user success:(void (^)(NSArray*))success fail:(void (^)(void))fail;

+ (void)shareIdea:(const Idea*)idea user:(const IdeaUser*)user success:(void (^)(NSString*))success fail:(void (^)(void))fail;

+ (void)removeIdea:(const NSString*)uuid success:(void (^)(void))success fail:(void (^)(void))fail;

+ (void)modifyIdea:(const Idea*)idea success:(void (^)(void))success fail:(void (^)(void))fail;

+ (void)getIdea:(const NSString*)uuid success:(void (^)(Idea*))success fail:(void (^)(void))fail;;

+ (void)getComments:(const Idea*)idea success:(void (^)(NSArray*))success fail:(void (^)(void))fail;

+ (void)likeIdea:(const Idea*)idea success:(void (^)(int))success fail:(void (^)(void))fail;

+ (void)dislikeIdea:(const Idea*)idea success:(void (^)(int))success fail:(void (^)(void))fail;

+ (void)addComment:(const Idea*)idea fromUser:(IdeaUser*)fromUser comment:(const IdeaComment*)comment success:(void (^)(NSString*))success fail:(void (^)(void))fail;

+ (void)removeComment:(const IdeaComment*)comment success:(void (^)(void))success fail:(void (^)(void))fail;


@end
