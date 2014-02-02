//
//  NSUserDefaults+DefaultValue.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "NSUserDefaults+DefaultValue.h"

@implementation NSUserDefaults (NSUserDefaultsDefaultValue)

- (NSString*)stringForKey:(NSString*)defaultName defaultValue:(NSString*)defaultValue {
    NSString* value = [self stringForKey:defaultName];
    return value != nil ? value : defaultValue;
}

- (bool)boolForKey:(NSString*)defaultName defaultValue:(bool)defaultValue {
    if([self objectForKey:defaultName] != nil) {
        return [self boolForKey:defaultName];
    }
    return defaultValue;
}

@end
