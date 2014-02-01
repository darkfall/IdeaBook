//
//  Idea.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "Idea.h"

@implementation Idea

- (id)init {
    if(self = [super init]) {
        _shared = [NSNumber numberWithBool:NO];
        _latitude = [NSNumber numberWithInt:0];
        _longitude = [NSNumber numberWithInt:0];
        _likes = [NSNumber numberWithDouble:0];
        _dislikes = [NSNumber numberWithDouble:0];
        _uuid = _title = _content = _time = _geoDescription = @"";
    }
    return self;
}

@end
