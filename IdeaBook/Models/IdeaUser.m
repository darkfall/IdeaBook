//
//  IdeaUser.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaUser.h"

@implementation IdeaUser

- (id)init {
    if(self = [super init]) {
        _latitude = [NSNumber numberWithInt:0];
        _longitude = [NSNumber numberWithInt:0];
        _uuid = _name = _lastUpdateTime = _avatarPath =  @"";
    }
    return self;
}

@end
