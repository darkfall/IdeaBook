//
//  GeoLocationManager.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "GeoLocationManager.h"

@implementation GeoLocationManager

+ (GeoLocationManager*)sharedInstance {
    static GeoLocationManager* instance = NULL;
    
    @synchronized(self) {
        if(!instance) {
            instance = [[GeoLocationManager alloc] init];
        }
        return instance;
    }
}


+ (bool)geoLocationEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (void)startUpdate {
    if(self->_locationManager == nil) {
        self->_locationManager = [[CLLocationManager alloc] init];
        
        self->_locationManager.delegate = self;
        // 100m
        self->_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // 100m
        self->_locationManager.distanceFilter = 100;
    }
    
    [self->_locationManager startUpdatingLocation];
    
    _running = true;
}

- (void)stopUpdate {
    [self->_locationManager stopUpdatingLocation];
    
    _running = false;
}


- (CLLocationDistance)distanceFromCurrentLocation:(double)latitude longitude:(double)longitude {
    if(self.lastLocation != nil) {
        CLLocation* new_loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        return [[self lastLocation] distanceFromLocation:new_loc] * 0.000621371192;
    } else {
        return -1.f;
    }
}

// CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.lastLocation = [locations lastObject];
    NSLog(@"[GeoLoc] Got last location: %@", self.lastLocation);
    
    if(self.delegate != nil) {
        [self.delegate receivedGeoLocation:self.lastLocation];
    }
}

@end
