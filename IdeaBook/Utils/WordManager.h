//
//  WordManager.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordManager : UICollectionViewLayout

+ (WordManager*)sharedInstance;

- (NSArray*)getWords;

- (void)unload;

@end