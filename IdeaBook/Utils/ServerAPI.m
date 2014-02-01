//
//  ServerCommunication.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "ServerAPI.h"
#import "JSONSerialization.h"

#import "../Models/IdeaUser.h"
#import "../Models/IdeaComment.h"
#import "../Models/Idea.h"
#import "../Models/IdeaCategory.h"

#import "../AFNetworking/AFHTTPRequestOperationManager.h"

@implementation ServerAPI

#define kServerBaseUrl "http://darkfall.me:81/ideamapx/"

#define kRegisterUserUrl        @ kServerBaseUrl "new_user"
#define kGetIdeasNearbyUrl      @ kServerBaseUrl "get_ideas_nearby"
#define kGetSharedIdeasUrl      @ kServerBaseUrl "get_shared_ideas"
#define kShareIdeaUrl           @ kServerBaseUrl "new_idea"
#define kRemoveIdeaUrl          @ kServerBaseUrl "remove_idea"
#define kModifyIdeaUrl          @ kServerBaseUrl "modifiy_idea"
#define kGetIdeaUrl             @ kServerBaseUrl "get_idea"
#define kGetCommentsUrl         @ kServerBaseUrl "get_comments"
#define kLikeIdeaUrl            @ kServerBaseUrl "like_idea"
#define kDislikeIdeaUrl         @ kServerBaseUrl "dislike_idea"
#define kAddCommentUrl          @ kServerBaseUrl "add_comment"
#define kRemoveCommentUrl       @ kServerBaseUrl "remove_comment"


#define API_SUCCEED(respObj) \
    respObj[@"status"] == nil || ![respObj[@"status"] isEqual: @"failed"]


+ (void)registerNewUser:(const IdeaUser*)user success:(void (^)(void))success fail:(void (^)(void))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": user.uuid,
                                 @"name": user.name,
                                 @"latitude": user.latitude,
                                 @"longitude": user.longitude};
    
    [manager POST:kRegisterUserUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success();
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] registerNewUser error: %@", error);
              fail();
          }
     ];
}

+ (void)getIdeasNearby:(double)latitude longitude:(double)longitude success:(void (^)(NSArray*))success fail:(void (^)(void))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"latitude": [NSNumber numberWithDouble:latitude],
                                 @"longitude": [NSNumber numberWithDouble:longitude]};
    
    [manager GET:kGetIdeasNearbyUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(API_SUCCEED(responseObject)) {
                 NSArray* ideasDict = responseObject[@"ideas"];
                 NSMutableArray* ideas = [[NSMutableArray alloc] initWithCapacity:[ideasDict count]];
                 for(NSDictionary* ideaDict in ideasDict) {
                     Idea* idea = [JSONSerialization deserializeIdea:ideaDict];
                     if(idea != nil && idea.uuid.length > 0) {
                         [ideas addObject:idea];
                     } else {
                         NSLog(@"getIdeasNearby: Got invalid idea: %@", idea);
                     }
                 }
                 success(ideas);
             }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] getIdeasNearby error: %@", error);
              fail();
          }
     ];
}

+ (void)getSharedIdeas:(const IdeaUser*)user success:(void (^)(NSArray*))success fail:(void (^)(void))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": user.uuid};
    
    [manager GET:kGetSharedIdeasUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(API_SUCCEED(responseObject)) {
                 NSArray* ideasDict = responseObject[@"ideas"];
                 NSMutableArray* ideas = [[NSMutableArray alloc] initWithCapacity:[ideasDict count]];
                 for(NSDictionary* ideaDict in ideasDict) {
                     Idea* idea = [JSONSerialization deserializeIdea:ideaDict];
                     if(idea != nil && idea.uuid.length > 0) {
                         [ideas addObject:idea];
                     } else {
                         NSLog(@"getIdeasNearby: Got invalid idea: %@", idea);
                     }
                 }
                 success(ideas);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getSharedIdeas error: %@", error);
             fail();
         }
     ];
}

+ (void)shareIdea:(const Idea*)idea user:(const IdeaUser*)user success:(void (^)(NSString*))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": user.uuid,
                                 @"title": idea.title,
                                 @"content": idea.content,
                                 @"latitude": idea.latitude,
                                 @"longitude": idea.longitude,
                                 @"geo_desp": idea.geoDescription};
    
    [manager POST:kShareIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success(responseObject[@"data"]);
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] shareIdea error: %@", error);
              fail();
          }
    ];
    
}

+ (void)removeIdea:(const NSString*)uuid success:(void (^)(void))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": uuid};
    
    [manager POST:kRemoveIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success();
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] removeIdea error: %@", error);
              fail();
          }
     ];
    
}

+ (void)modifyIdea:(const Idea*)idea success:(void (^)(void))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": idea.uuid,
                                 @"content": idea.content,
                                 @"title": idea.title};
    
    [manager POST:kModifyIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success();
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] modifyIdea error: %@", error);
              fail();
          }
     ];

}

+ (void)getIdea:(const NSString*)uuid success:(void (^)(Idea*))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": uuid};
    
    [manager GET:kGetIdeaUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(API_SUCCEED(responseObject)) {
                 Idea* idea = [JSONSerialization deserializeIdea:responseObject[@"idea"]];
                 
                 if(idea != nil && idea.uuid.length > 0)
                     success(idea);
                 else
                     fail();
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getIdea error: %@", error);
             fail();
         }
     ];
    
}

+ (void)getComments:(const Idea*)idea success:(void (^)(NSArray*))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": idea.uuid};
    
    [manager GET:kGetCommentsUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(API_SUCCEED(responseObject)) {
                 NSArray* commentsDict = responseObject[@"comments"];
                 NSMutableArray* comments = [[NSMutableArray alloc] initWithCapacity:[commentsDict count]];
                 for(NSDictionary* commentDict in commentsDict) {
                     IdeaComment* comment = [JSONSerialization deserializeComment:commentDict];
                     if(idea != nil) {
                         [comments addObject:comment];
                     } else {
                         NSLog(@"getIdeasNearby: Got invalid idea: %@", idea);
                     }
                 }
                 success(comments);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getComments error: %@", error);
             fail();
         }
     ];
    
}

+ (void)likeIdea:(const Idea*)idea success:(void (^)(int))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": idea.uuid};
    
    [manager POST:kLikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success([responseObject[@"data"] intValue]);
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] likeIdea error: %@", error);
              fail();
          }
     ];
}

+ (void)dislikeIdea:(const Idea*)idea success:(void (^)(int))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": idea.uuid};
    
    [manager POST:kDislikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success([responseObject[@"data"] intValue]);
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] dislikeIdea error: %@", error);
              fail();
          }
     ];
}

+ (void)addComment:(const Idea*)idea fromUser:(IdeaUser*)fromUser comment:(const IdeaComment*)comment success:(void (^)(NSString*))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": fromUser.uuid,
                                 @"content": comment.content};
    
    [manager POST:kAddCommentUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success(responseObject[@"uuid"]);
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] addComment error: %@", error);
              fail();
          }
     ];
}

+ (void)removeComment:(const IdeaComment*)comment success:(void (^)(void))success fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": comment.uuid};
    
    [manager POST:kRemoveIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  success();
              } else {
                  fail();
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] removeComment error: %@", error);
              fail();
          }
     ];
}

@end
