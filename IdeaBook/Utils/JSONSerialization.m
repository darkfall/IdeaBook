//
//  JSONSerialization.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "JSONSerialization.h"

#import "../Models/IdeaUser.h"
#import "../Models/IdeaComment.h"
#import "../Models/Idea.h"
#import "../Models/IdeaCategory.h"

@implementation JSONSerialization

+ (id)genericDeserializeData:(NSDictionary*)dict target:(id)target {
    for(NSString* key in dict) {
        if([target respondsToSelector:NSSelectorFromString(key)]) {
            [target setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return target;
}

+ (Idea*)deserializeIdea:(NSDictionary*)dict {
    return [JSONSerialization genericDeserializeData:dict target:[[Idea alloc] init]];
}

+ (IdeaComment*)deserializeComment:(NSDictionary*)dict {
    return [JSONSerialization genericDeserializeData:dict target:[[IdeaComment alloc] init]];
}

+ (IdeaUser*)deserializeUser:(NSDictionary*)dict {
    return [JSONSerialization genericDeserializeData:dict target:[[IdeaUser alloc] init]];
}

+ (NSDictionary*)serializeIdea:(Idea*)idea {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:idea.title forKey:@"title"];
    [dict setValue:idea.content forKey:@"content"];
    [dict setValue:idea.shared forKey:@"shared"];
    [dict setValue:idea.uuid forKey:@"uuid"];
    [dict setValue:idea.latitude forKey:@"latitude"];
    [dict setValue:idea.longitude forKey:@"longitude"];
    [dict setValue:idea.time forKey:@"time"];
    [dict setValue:idea.likes forKey:@"likes"];
    [dict setValue:idea.dislikes forKey:@"dislikes"];
    [dict setValue:idea.geoDescription forKey:@"geoDescription"];
    
    return dict;
}

@end
