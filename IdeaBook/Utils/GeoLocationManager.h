//
//  GeoLocationManager.h
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GeoLocationManagerDelegate

- (void)receivedGeoLocation:(CLLocation*)location;

@end

@interface GeoLocationManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager* _locationManager;
}

@property (strong, nonatomic) CLLocation* lastLocation;
@property (nonatomic) bool running;

@property (weak, nonatomic) id<GeoLocationManagerDelegate> delegate;

+ (GeoLocationManager*)sharedInstance;
+ (bool)geoLocationEnabled;

- (void)startUpdate;
- (void)stopUpdate;

- (CLLocationDistance)distanceFromCurrentLocation:(double)latitude longitude:(double)longitude;

@end
