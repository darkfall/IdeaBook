//
//  NearbyIdeaTableViewCell.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idea;

@interface IdeaNearbyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ideaTitle;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numDislikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (weak, nonatomic) Idea* idea;

@end
