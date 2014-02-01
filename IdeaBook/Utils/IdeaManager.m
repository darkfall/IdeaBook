//
//  IdeaManager.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaManager.h"

#import "../Models/Idea.h"

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
    
    if(withNotification) {
        if(_delegate)
            [_delegate ideaRemoved:idea];
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
            [_delegate ideaAdded:idea];
    }
    
    [self saveDataToDisk];
}

- (void)removeIdea:(Idea*)idea withNotification:(BOOL)withNotification {
    if([_ideas containsObject:idea]) {
        [_ideas removeObject:idea];
        
        [self saveDataToDisk];
        
        if(withNotification) {
            if(_delegate)
                [_delegate ideaRemoved:idea];
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
                [_delegate ideaRemoved:idea];
        }
    }
}

@end
