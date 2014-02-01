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

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.uuid forKey:@"difficulty"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.geoDescription forKey:@"geoDescription"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.likes forKey:@"likes"];
    [encoder encodeObject:self.dislikes forKey:@"dislikes"];
    [encoder encodeObject:self.shared forKey:@"shared"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.uuid = [decoder decodeObjectForKey:@"difficulty"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.geoDescription = [decoder decodeObjectForKey:@"geoDescription"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.likes = [decoder decodeObjectForKey:@"likes"];
        self.dislikes = [decoder decodeObjectForKey:@"dislikes"];
        self.shared = [decoder decodeObjectForKey:@"shared"];
    }
    return self;
}

@end
