//
//  IdeaNearbyDetailViewController.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idea;

@interface IdeaNearbyDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Idea* idea;

@end
