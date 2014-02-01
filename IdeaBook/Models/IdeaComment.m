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
        _user = nil;
        _idea = nil;
        
        _content = _uuid = @"";
    }
    return self;
}

@end
