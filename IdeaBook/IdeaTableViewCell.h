//
//  IdeaTableViewCell.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idea;

@interface IdeaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ideaTitle;
@property (weak, nonatomic) IBOutlet UILabel *ideaCreationTime;
@property (weak, nonatomic) IBOutlet UIButton *ideaShareButton;

@property (weak, nonatomic) Idea* idea;
@property (weak, nonatomic) UITableView* parentTableView;

@end
