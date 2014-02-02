//
//  IdeaNearbyCommentCell.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaComment;

@interface IdeaNearbyCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *commentDetail;
@property (weak, nonatomic) IBOutlet UILabel *commentorName;
@property (weak, nonatomic) IBOutlet UIButton *removeCommentButton;

@property (weak, nonatomic) IdeaComment* comment;
@property (weak, nonatomic) UIViewController* parentViewController;

@end
