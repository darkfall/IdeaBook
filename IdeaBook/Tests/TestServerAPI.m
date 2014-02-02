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
#import "../Models/Idea.h"
#import "../Models/IdeaComment.h"
#import "../Models/IdeaCategory.h"

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
    
    Idea* idea = [[Idea alloc] init];
    idea.title = @"test1";
    idea.content = @"hello";
    [ServerAPI shareIdea:idea user:user success:^(NSString *uuid) {
        
        NSLog(@"[TestServerAPI] shareIdea: got uuid = %@", idea.uuid);
        
        [ServerAPI likeIdea:idea success:^(int numLikes, int numDislikes) {
            NSLog(@"[TestServerAPI] likeIdea: got likes = %d dislikes = %d", numLikes, numDislikes);
            
            [ServerAPI dislikeIdea:idea success:^(int numLikes, int numDislikes) {
                NSLog(@"[TestServerAPI] dislikeIdea: got likes = %d dislikes = %d", numLikes, numDislikes);
                
                [ServerAPI addComment:idea comment:@"test" success:^(NSString* uuid) {
                    NSLog(@"[TestServerAPI] addComment: got comment uuid = %@", uuid);
                    
                    [ServerAPI getComments:idea success:^(NSArray *comments) {
                        
                        NSLog(@"[TestServerAPI] getComments = %d\n", comments.count);
                        
                        [ServerAPI removeComment:uuid success:^() {
                            NSLog(@"[TestServerAPI] removeComment: success");
                            
                            [ServerAPI removeIdea:idea.uuid success:^() {
                                NSLog(@"[TestServerAPI] removeIdea: success");
                                
                            } fail:^{
                                
                                NSLog(@"[TestServerAPI] removeIdea: failed");
                                
                            }];
                            
                            
                        } fail:^{
                            
                            NSLog(@"[TestServerAPI] removeComment: failed");
                            
                        }];

                        
                    } fail:^{
                        
                        NSLog(@"[TestServerAPI] getComments:failed");
                        
                    }];
                    
                } fail:^{
                    
                    NSLog(@"[TestServerAPI] addComment: failed");
                    
                }];
                
            } fail:^{
                
                NSLog(@"[TestServerAPI] dislikeIdea: failed");
                
            } any:nil];
            
        } fail:^{
            
            NSLog(@"[TestServerAPI] likeIdea: failed");
            
        } any:nil];
        
    } fail:^{
        
        NSLog(@"[TestServerAPI] shareIdea: failed");
        
    }];
}

@end
