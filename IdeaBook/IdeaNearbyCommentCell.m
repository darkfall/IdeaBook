//
//  IdeaNearbyCommentCell.m
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaNearbyCommentCell.h"
#import "IdeaNearbyCellCommon.h"

@implementation IdeaNearbyCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setFrame:(CGRect)frame {
    SET_UP_CELL
}

@end
