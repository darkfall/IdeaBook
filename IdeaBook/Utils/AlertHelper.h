//
//  AlertHelper.h
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

+ (void)showNZAlert:(NSString*)title message:(NSString*)message style:(NSInteger)style;

+ (void)showNZAlert:(NSString*)title message:(NSString*)message style:(NSInteger)style duration:(CGFloat)duration;

@end
