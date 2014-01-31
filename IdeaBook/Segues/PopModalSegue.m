//
//  PopModalSegue.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "PopModalSegue.h"

@implementation PopModalSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    [src dismissViewControllerAnimated:YES completion:^() {
        
    }];
}

@end
