//
//  AlertHelper.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "AlertHelper.h"

#import "NZAlertView.h"

@implementation AlertHelper

+ (void)showNZAlert:(NSString*)title message:(NSString*)message style:(NSInteger)style {
    [AlertHelper showNZAlert:title message:message style:style duration:1.0f];
}

+ (void)showNZAlert:(NSString*)title message:(NSString*)message style:(NSInteger)style duration:(CGFloat)duration {
    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:style
                                                      title:title
                                                    message:message
                                                   delegate:nil];
    
    [alert setAlertDuration:duration];
    [alert setBlurParameter:0.1f];
    [alert setTextAlignment:NSTextAlignmentCenter];
    
    [alert show];
}



@end
