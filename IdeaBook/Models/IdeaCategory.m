//
//  IdeaCategory.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaCategory.h"

@implementation IdeaCategory

- (id)init {
    if(self = [super init]) {
        _name = _uuid = nil;
        _ideas = nil;
    }
    return self;
}


@end
