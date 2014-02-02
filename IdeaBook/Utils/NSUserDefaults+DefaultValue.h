//
//  NSUserDefaults+DefaultValue.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

// Simple category extends NSUserDefaults with value getters + default value

@interface NSUserDefaults (NSUserDefaultsDefaultValue)

- (NSString*)stringForKey:(NSString*)defaultName defaultValue:(NSString*)defaultValue;
- (bool)boolForKey:(NSString*)defaultName defaultValue:(bool)defaultValue;

@end
