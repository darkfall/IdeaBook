//
//  IdeaNearbyCommentCell.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaNearbyCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *commentDetail;
@property (weak, nonatomic) IBOutlet UILabel *commentorName;


@end
