//
//  IdeaFountainCollectionViewLayout.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaFountainCollectionViewLayout : UICollectionViewLayout

- (void)reset;
- (void)removeItemAtIndexPath:(NSIndexPath*)indexPath completion:(void (^)(void))completion;

- (void)removeGravityAtIndexPath:(NSIndexPath*)indexPath;

@end
