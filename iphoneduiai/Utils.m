//
//  Utils.m
//  WhoHelp
//
//  Created by cloud on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "math.h"
#import "LocationController.h"
#import "NSDate-Utilities.h"

@implementation Utils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - handling errors
+ (void)helpNotificationForTitle: (NSString *)title forMessage: (NSString *)message
{
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [Notpermitted show];
    [Notpermitted release];
}

+ (void)warningNotification:(NSString *)message
{
    [self helpNotificationForTitle:@"警告" forMessage:message];
}

+ (void)errorNotification:(NSString *)message
{
    [self helpNotificationForTitle:@"错误" forMessage:message];  
}

+ (void)tellNotification:(NSString *)message
{
    [self helpNotificationForTitle:nil forMessage:message];  
}

#pragma mark - date formate to human readable
+ (NSString *)descriptionForTime:(NSDate *)date
{
    // convert the time formate to human reading.
    // i18n FIXME
    NSInteger timePassed = abs([date timeIntervalSinceNow]);
    
    NSString *dateString = nil;
    if (timePassed < 60){
        dateString = [NSString stringWithFormat:@"%d秒前", timePassed];
    }else{
        if (timePassed < 60*60){
            dateString = [NSString stringWithFormat:@"%d分钟前", timePassed/60];
        }else{
            NSDateFormatter *dateFormat = [NSDateFormatter alloc];
            [dateFormat setLocale:[NSLocale currentLocale]];
            
            NSString *dateFormatString = nil;
            
            // compare the now and then time.
            NSDateComponents *curDateComp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
            NSDateComponents *dateComp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
            
            if (timePassed < 24*60*60 && curDateComp.day == dateComp.day ){
                dateFormatString = [NSString stringWithFormat:@"%@", [NSDateFormatter dateFormatFromTemplate:@"h:mm a" options:0 locale:[NSLocale currentLocale]]];
            }else{
                dateFormatString = [NSDateFormatter dateFormatFromTemplate:@"M-d H:m" options:0 locale:[NSLocale currentLocale]];
            }
            [dateFormat setDateFormat:dateFormatString];
            dateString = [dateFormat stringFromDate:date];
            
            [dateFormat release];
        }
    }
    return dateString;
}

+ (NSString *)curDateParam
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *str = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat release];
    //    NSLog(@"date: %@", str);
    
    return str;
}

+ (NSString *)dateDescWithDate:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormat stringFromDate:date];
    [dateFormat release];
    //    NSLog(@"date: %@", str);
    
    return str;
}

#pragma mark - thumbnail image
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage;
    
    if (nil == image) {        
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newimage;
    
}

+(float)distanceFrom:(CLLocationCoordinate2D)posA to:(CLLocationCoordinate2D)posB
{
//    float d = 6378137*acos(sin(posA.latitude)*sin(posB.latitude)*cos(posA.longitude - posB.longitude)+cos(posA.latitude)*cos(posB.latitude))*M_PI/180;
    CLLocation *posAL = [[[CLLocation alloc] initWithLatitude:posA.latitude
                                                    longitude:posA.longitude] autorelease];
    CLLocation *posBL = [[[CLLocation alloc] initWithLatitude:posB.latitude
                                                    longitude:posB.longitude] autorelease];
    return [posAL distanceFromLocation:posBL];
    
}

#pragma mark - random number

+ (NSString *)genRandStringLength:(int)len 
{
    //NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSString *letters = @"0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: arc4random()%[letters length]]];
    }
    
    return randomString;
    
}

#pragma mark - location
+ (CLLocationCoordinate2D)getCurLocation
{
    __block CLLocationCoordinate2D curLocation;
    if ([LocationController sharedInstance].allow) {
        [[[LocationController sharedInstance] locationManager] startUpdatingLocation];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            curLocation = [LocationController sharedInstance].location.coordinate;
            [[[LocationController sharedInstance] locationManager] stopUpdatingLocation];
        });
        
    } else {
        curLocation = CLLocationCoordinate2DMake(0.0, 0.0);
    }
    
    return curLocation;
}

@end
