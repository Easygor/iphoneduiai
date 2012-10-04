//
//  LocationController.h
//  WhoHelp
//
//  Created by cloud on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate <NSObject>
@optional
- (void)locationUpdate:(CLLocation*)location;
- (void)didOnChangeStatusToAllow:(CLLocationManager*)manager;
- (void)didOnChangeStatusToUneabled:(CLLocationManager *)manager;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, assign) id <LocationControllerDelegate> delegate;
@property (nonatomic) BOOL allow;

+ (LocationController*)sharedInstance; // Singleton method

@end

