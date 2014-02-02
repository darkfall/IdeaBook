//
//  IdeaManager.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaManager.h"

#import "../Models/Idea.h"


#import "UserManager.h"
#import "ServerAPI.h"
#import "GeoLocationManager.h"
#import "AlertHelper.h"

#import "DejalActivityView.h"
#import "NZAlertView.h"

// local idea manager
@implementation IdeaManager

+ (IdeaManager*)sharedInstance {
    static IdeaManager* instance = NULL;
    
    @synchronized(self) {
        if(!instance) {
            instance = [[IdeaManager alloc] init];
        }
        return instance;
    }
}

- (id)init {
    if(self = [super init]) {
        [self loadDataFromDisk];
    }
    return self;
}

-(NSString *)getPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath;
    documentPath = [paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"ideas"];
}

-(void)saveDataToDisk {
    [NSKeyedArchiver archiveRootObject:self.ideas toFile:[self getPath]];
}

-(void)loadDataFromDisk {
    _ideas = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath]];
    if(_ideas == nil) {
        _ideas = [[NSMutableArray alloc] init];
    }
}

- (void)ideaChanged:(Idea*)idea withNotification:(BOOL)withNotification; {
    [self saveDataToDisk];
    
    if([idea.shared boolValue]) {
        [ServerAPI modifyIdea:idea success:^{
        
        } fail:^{
            
        }];
    }
    
    if(withNotification) {
        if(_delegate)
            [_delegate ideaChanged:idea index:[_ideas indexOfObject:idea]];
    }
}

- (void)addIdea:(NSString*)content title:(NSString*)title withNotification:(BOOL)withNotification; {
    Idea* idea = [[Idea alloc] init];
    idea.content = content;
    idea.title = title;
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    idea.time = [formatter stringFromDate:[NSDate date]];
    
    [_ideas addObject:idea];
    if(withNotification) {
        if(_delegate)
            [_delegate ideaAdded:idea index:_ideas.count - 1];
    }
    
    [self saveDataToDisk];
}

- (void)removeIdea:(Idea*)idea withNotification:(BOOL)withNotification {
    NSUInteger index = [_ideas indexOfObject:idea];
    if(index != NSNotFound) {
        [_ideas removeObject:idea];
        
        [self saveDataToDisk];
        
        if(withNotification) {
            if(_delegate)
                [_delegate ideaRemoved:idea index:index];
        }
    }
}

- (void)removeAtIndex:(NSUInteger)index withNotification:(BOOL)withNotification {
    if(_ideas.count > index) {
        Idea* idea = [_ideas objectAtIndex:index];
        [_ideas removeObjectAtIndex:index];
        
        [self saveDataToDisk];
        
        if(withNotification) {
            if(_delegate)
                [_delegate ideaRemoved:idea index:index];
        }
    }
}

- (void)shareOrCancelShareIdea:(Idea*)idea onView:(UIView*)view withNotification:(BOOL)notification onShared:(void (^)(void))onShared onCancelled:(void (^)(void))onCancelled {
    
    [DejalBezelActivityView activityViewForView:view];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if(![idea.shared boolValue]) {
            [ServerAPI shareIdea:idea user:[UserManager getCurrentUser] success:^(NSString* uuid) {
                [DejalActivityView removeView];
                
                [self ideaChanged:idea withNotification:YES];
                if(onShared)
                    onShared();
                
                if(notification)
                    [AlertHelper showNZAlert:@"Info" message:@"Idea shared" style:NZAlertStyleSuccess];
                
            } fail:^{
                [DejalActivityView removeView];
                
                [AlertHelper showNZAlert:@"Error" message:@"Share idea failed" style:NZAlertStyleError];
            }];
            
        } else {
            
            assert(idea.uuid != nil && idea.uuid.length > 0);
            
            [ServerAPI removeIdea:idea.uuid success:^{
                
                [DejalActivityView removeView];
                idea.shared = [NSNumber numberWithBool:NO];
                [self ideaChanged:idea withNotification:YES];
                if(onCancelled)
                    onCancelled();
                                
            } fail:^{
                
                [DejalActivityView removeView];
                idea.shared = [NSNumber numberWithBool:NO];
                [AlertHelper showNZAlert:@"Error" message:@"Cancel idea share failed" style:NZAlertStyleError];
                
            }];
        }
    });
}

@end
