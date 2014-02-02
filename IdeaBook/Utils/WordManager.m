//
//  WordManager.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "WordManager.h"

@interface WordManager () {
    NSArray* _words;
}

@end

@implementation WordManager

+ (WordManager*)sharedInstance {
    static WordManager* instance = NULL;
    
    @synchronized(self) {
        if(!instance) {
            instance = [[WordManager alloc] init];
        }
        return instance;
    }
}

- (void)load {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"db"];
    
    NSError* error;
    NSString* wordsStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(error != nil) {
        _words = nil;
    } else {
        _words = [wordsStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
}

- (void)unload {
    
}

- (NSArray*)getWords {
    if(_words == nil || _words.count == 0) {
        [self load];
    }
    return _words;
}


@end
