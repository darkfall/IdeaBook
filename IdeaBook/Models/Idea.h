//
//  Idea.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Idea : NSObject <NSCoding>

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSString* geoDescription;

@property (strong, nonatomic) NSNumber* latitude;
@property (strong, nonatomic) NSNumber* longitude;

@property (strong, nonatomic) NSNumber* likes;
@property (strong, nonatomic) NSNumber* dislikes;

@property (strong, nonatomic) NSNumber* shared;


@end
