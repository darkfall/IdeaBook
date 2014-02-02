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
#import "../Utils/UserManager.h"

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
#define kCancelLikeIdeaUrl      @ kServerBaseUrl "cancel_like_idea"
#define kCancelDislikeIdeaUrl   @ kServerBaseUrl "cancel_dislike_idea"
#define kAddCommentUrl          @ kServerBaseUrl "add_comment"
#define kRemoveCommentUrl       @ kServerBaseUrl "remove_comment"


#define API_SUCCEED(respObj) \
    respObj[@"status"] == nil || ![respObj[@"status"] isEqual: @"failed"]


#define PARSE_LIKE_DISLIKE_RESULT(respObj, idea, call) \
    NSArray* resp = [respObj[@"data"] componentsSeparatedByString:@";"]; \
    idea.likes = [NSNumber numberWithInt:[resp[0] intValue]]; \
    idea.dislikes = [NSNumber numberWithInt:[resp[1] intValue]]; \
    if(call) \
        call([idea.likes intValue], [idea.dislikes intValue]); \


#define CALL(x) if(x) x()


+ (void)registerNewUser:(const IdeaUser*)user
                success:(void (^)(void))success
                   fail:(void (^)(void))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": user.uuid,
                                 @"name": user.name,
                                 @"latitude": user.latitude,
                                 @"longitude": user.longitude};
    
    [manager POST:kRegisterUserUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  CALL(success);
              } else {
                  NSLog(@"[ServerAPI] registerNewUser error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] registerNewUser error: %@", error);
              CALL(fail);
          }
     ];
}

+ (void)getIdeasNearby:(double)latitude
             longitude:(double)longitude
               success:(void (^)(NSArray*))success
                  fail:(void (^)(void))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"latitude": [NSNumber numberWithDouble:latitude],
                                 @"longitude": [NSNumber numberWithDouble:longitude],
                                 @"uuid": [UserManager getCurrentUser].uuid};
    
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
                 if(success)
                     success(ideas);
             } else {
                 
                 NSLog(@"[ServerAPI] getIdeasNearby error: %@", responseObject[@"error"]);
                 CALL(fail);
             }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] getIdeasNearby error: %@", error);
              CALL(fail);
          }
     ];
}

+ (void)getSharedIdeas:(const IdeaUser*)user
               success:(void (^)(NSArray*))success
                  fail:(void (^)(void))fail {
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
                         NSLog(@"[ServerAPI] getIdeasNearby: Got invalid idea: %@", idea);
                     }
                 }
                 if(success)
                     success(ideas);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getSharedIdeas error: %@", error);
             CALL(fail);
         }
     ];
}

+ (void)shareIdea:(Idea*)idea
             user:(const IdeaUser*)user
          success:(void (^)(NSString*))success fail:(void (^)(void))fail {
    
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
                  idea.uuid = responseObject[@"data"];
                  idea.shared = [NSNumber numberWithBool:YES];
                  success(idea.uuid);
              } else {
                  NSLog(@"[ServerAPI] shareIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] shareIdea error: %@", error);
              CALL(fail);
          }
    ];
    
}

+ (void)removeIdea:(const NSString*)uuid
           success:(void (^)(void))success
              fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": uuid};
    
    NSLog(@"[Server API] Removing idea from sharing: %@", uuid);
    [manager POST:kRemoveIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  CALL(success);
              } else {
                  NSLog(@"[ServerAPI] removeIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] removeIdea error: %@", error);
              CALL(fail);
          }
     ];
    
}

+ (void)modifyIdea:(const Idea*)idea
           success:(void (^)(void))success
              fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": idea.uuid,
                                 @"content": idea.content,
                                 @"title": idea.title};
    
    [manager POST:kModifyIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  NSLog(@"[ServerAPI] modifyIdea succeed");
                  CALL(success);
              } else {
                  NSLog(@"[ServerAPI] modifyIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] modifyIdea error: %@", error);
              CALL(fail);
          }
     ];

}

+ (void)getIdea:(const NSString*)uuid
        success:(void (^)(Idea*))success
           fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": uuid};
    
    [manager GET:kGetIdeaUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(API_SUCCEED(responseObject)) {
                 Idea* idea = [JSONSerialization deserializeIdea:responseObject[@"idea"]];
                 
                 if(idea != nil && idea.uuid.length > 0)
                     success(idea);
                 else {
                     NSLog(@"[ServerAPI] getIdea error: %@", responseObject[@"error"]);
                     CALL(fail);
                 }
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getIdea error: %@", error);
             CALL(fail);
         }
     ];
    
}

+ (void)getComments:(const Idea*)idea
            success:(void (^)(NSArray*))success
               fail:(void (^)(void))fail {
    
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
                         NSLog(@"[ServerAPI] getComments: Got invalid idea: %@", idea);
                     }
                 }
                 success(comments);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"[ServerAPI] getComments error: %@", error);
             CALL(fail);
         }
     ];
    
}

+ (void)likeIdea:(Idea*)idea
         success:(void (^)(int, int))success
            fail:(void (^)(void))fail
             any:(void (^)(void))any {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": [UserManager getCurrentUser].uuid};
    
    [manager POST:kLikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  
                  PARSE_LIKE_DISLIKE_RESULT(responseObject, idea, success);
                  
                  idea.liked = [NSNumber numberWithInt:1];
                  idea.disliked = [NSNumber numberWithInt:0];
                  
              } else {
                  NSLog(@"[ServerAPI] likeIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
              CALL(any);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] likeIdea error: %@", error);
              CALL(fail);
            
              CALL(any);
          }
     ];
}

+ (void)dislikeIdea:(const Idea*)idea
            success:(void (^)(int, int))success
               fail:(void (^)(void))fail
                any:(void (^)(void))any {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": [UserManager getCurrentUser].uuid};
    
    [manager POST:kDislikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  
                  PARSE_LIKE_DISLIKE_RESULT(responseObject, idea, success);
                  
                  
                  idea.liked = [NSNumber numberWithInt:0];
                  idea.disliked = [NSNumber numberWithInt:1];
                  
              } else {
                  NSLog(@"[ServerAPI] dislikeIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
              
              CALL(any);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] dislikeIdea error: %@", error);
              CALL(fail);
              
              CALL(any);
          }
     ];
}

+ (void)cancelLikeIdea:(Idea*)idea
               success:(void (^)(int, int))success
                  fail:(void (^)(void))fail
                   any:(void (^)(void))any {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": [UserManager getCurrentUser].uuid};
    
    [manager POST:kCancelLikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  
                  PARSE_LIKE_DISLIKE_RESULT(responseObject, idea, success);
                  
                  idea.liked = [NSNumber numberWithInt:0];
                  
              } else {
                  NSLog(@"[ServerAPI] cancelLikeIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
              CALL(any);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] cancelLikeIdea error: %@", error);
              CALL(fail);
              
              CALL(any);
          }
     ];

}

+ (void)cancelDislikeIdea:(Idea*)idea
                  success:(void (^)(int, int))success
                     fail:(void (^)(void))fail
                      any:(void (^)(void))any {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": [UserManager getCurrentUser].uuid};
    
    [manager POST:kCancelDislikeIdeaUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  
                  PARSE_LIKE_DISLIKE_RESULT(responseObject, idea, success);
                  
                  idea.disliked = [NSNumber numberWithInt:0];
                  
              } else {
                  NSLog(@"[ServerAPI] cancelDislikeIdea error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
              CALL(any);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] cancelDislikeIdea error: %@", error);
              CALL(fail);
              
              CALL(any);
          }
     ];
    
}

+ (void)addComment:(const Idea*)idea
          fromUser:(const IdeaUser*)fromUser
           comment:(IdeaComment*)comment
           success:(void (^)(NSString*))success
              fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"idea_uuid": idea.uuid,
                                 @"user_uuid": fromUser.uuid,
                                 @"content": comment.content};
    
    [manager POST:kAddCommentUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  comment.uuid = responseObject[@"data"];
                  success(comment.uuid);
              } else {
                  NSLog(@"[ServerAPI] addComment error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] addComment error: %@", error);
              CALL(fail);
          }
     ];
}

+ (void)removeComment:(const IdeaComment*)comment
              success:(void (^)(void))success
                 fail:(void (^)(void))fail {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"uuid": comment.uuid};
    
    [manager POST:kRemoveCommentUrl
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(API_SUCCEED(responseObject)) {
                  CALL(success);
              } else {
                  NSLog(@"[ServerAPI] removeComment error: %@", responseObject[@"error"]);
                  CALL(fail);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"[ServerAPI] removeComment error: %@", error);
              CALL(fail);
          }
     ];
}

@end
