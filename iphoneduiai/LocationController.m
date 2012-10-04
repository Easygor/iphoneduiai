//
//  LocationController.m
//  WhoHelp
//
//  Created by cloud on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"

static LocationController* sharedCLDelegate = nil;

@implementation LocationController

- (void)dealloc
{
    [_delegate release];
    [_location release];
    [_locationManager release];
    [super dealloc];
    
}

- (BOOL)allow
{
    return  [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}

+ (LocationController*)sharedInstance {
    static LocationController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        _sharedInstance = [[LocationController alloc] initWithLocationManager:locationManager];
    });
    
    return _sharedInstance;
}

-(id)initWithLocationManager:(CLLocationManager *)locationManager
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.locationManager = locationManager;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    return self;
}



#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
    
    self.location = self.locationManager.location;
    
    if ([self.delegate respondsToSelector:@selector(locationUpdate:)]) {
        [self.delegate locationUpdate:self.location];
    }
    
    //NSLog(@"%f,%f", self.location.coordinate.latitude, self.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
    [self.locationManager stopUpdatingLocation];
    NSString *errorString;
    // We handle CoreLocation-related errors here
    switch ([error code]) {
            // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
            // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
        case kCLErrorDenied:
            errorString = @"需获取位置的授权";
            //            [Utils tellNotification:errorString];
            break;
        case kCLErrorLocationUnknown:
            errorString = @"获取位置信息出现未知错误";
            //            [Utils tellNotification:errorString];
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // do
            break;
            
        case kCLAuthorizationStatusAuthorized:
            if ([self.delegate respondsToSelector:@selector(didOnChangeStatusToAllow:)]) {
                [self.delegate didOnChangeStatusToAllow:manager];
            }
            break;
            
        case kCLAuthorizationStatusRestricted:
            // next
        case kCLAuthorizationStatusDenied:
            if ([self.delegate respondsToSelector:@selector(didOnChangeStatusToUneabled:)]) {
                [self.delegate didOnChangeStatusToUneabled:manager];
            }
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark Singleton Object Methods

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end