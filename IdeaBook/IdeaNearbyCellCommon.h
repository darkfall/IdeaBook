//
//  IdeaNearbyDetailViewCellCommon.h
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#ifndef IdeaBook_IdeaNearbyDetailViewCellCommon_h
#define IdeaBook_IdeaNearbyDetailViewCellCommon_h

#define SET_UP_CELL \
    frame.origin.x += 10;                                           \
    frame.size.width -= 2 * 10;                                     \
    [super setFrame:frame];                                         \
                                                                    \
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];     \
    [self.layer setShadowOffset:CGSizeMake(0, 0.5f)];               \
    [self.layer setShadowOpacity:0.5f];                             \
    [self.layer setShadowRadius:0.5f];                              \
                                                                    \
    [self.layer setCornerRadius:10];                                \
    [self.layer setMasksToBounds:YES];                              \

#endif
