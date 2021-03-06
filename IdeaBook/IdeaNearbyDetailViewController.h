//
//  IdeaNearbyDetailViewController.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idea;
@class IdeaComment;

@interface IdeaNearbyDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Idea* idea;

- (void)removeComment:(IdeaComment*)comment;

@end
