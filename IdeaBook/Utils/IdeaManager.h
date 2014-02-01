//
//  IdeaManager.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Idea;

@protocol IdeaManagerDelegate

- (void)ideaAdded:(Idea*)idea;
- (void)ideaRemoved:(Idea*)idea;

@end

@interface IdeaManager : NSObject {
    
}

@property (strong, nonatomic) NSMutableArray* ideas;
@property (weak, nonatomic) id<IdeaManagerDelegate> delegate;

+ (IdeaManager*)sharedInstance;

- (void)addIdea:(NSString*)content title:(NSString*)title withNotification:(BOOL)withNotification;;
- (void)removeIdea:(Idea*)idea withNotification:(BOOL)withNotification;
- (void)removeAtIndex:(NSUInteger)index withNotification:(BOOL)withNotification;
- (void)ideaChanged:(Idea*)idea withNotification:(BOOL)withNotification;;

- (void)saveDataToDisk;

@end