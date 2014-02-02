//
//  IdeaComment.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaComment.h"

@implementation IdeaComment

- (id)init {
    if(self = [super init]) {
        _content = _uuid = _user_name = _user_uuid = @"";
    }
    return self;
}

@end
