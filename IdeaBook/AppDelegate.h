//
//  AppDelegate.h
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils/GeoLocationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeoLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
