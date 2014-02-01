//
//  IdeaCategory.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdeaCategory : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSArray*  ideas;

@end
