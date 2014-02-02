//
//  IdeaNearbyDetailCell.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaNearbyDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextView *ideaContent;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLikeDislikeLabel;

@end
