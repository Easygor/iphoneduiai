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
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"

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
    } else if(timePassed < 60*60){
        dateString = [NSString stringWithFormat:@"%d分钟前", timePassed/60];
    } else if(timePassed < 60*60*24){
        dateString = [NSString stringWithFormat:@"%d小时前", timePassed/60];
    } else if(timePassed < 60*60*24*7){
        dateString = [NSString stringWithFormat:@"%d天前", timePassed/60];
    } else {
        dateString = @"1星期前";
    }
    
    return dateString;
}

+ (NSString *)descriptionForDistance:(NSInteger)d
{
    NSString *desc;
    if (d < 1000) {
        desc = [NSString stringWithFormat:@"%dm", d];
    } else if(d < 1000*1000){
        desc = [NSString stringWithFormat:@"%dkm", d];
    } else{
        desc = @"NA";
    }
    
    return desc;
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

+ (NSMutableDictionary*)queryParams
{
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:APPID forKey:@"appid"];
    [d setObject:KEY forKey:@"key"];
    [d setObject:PASS forKey:@"pass"];
    [d setObject:[[self class] curDateParam] forKey:@"date"];
    [d setObject:@"1.0" forKey:@"version"];
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];

    if (user) {
        [d setObject:user[@"accesskey"] forKey:@"accesskey"];
    }
    
    return d;
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

+ (void)scorePhotoWithUid:(NSString*)uid pid:(NSString*)pid block:(void(^)())block
{
//    [SVProgressHUD show];
    NSMutableDictionary *dp = [[self class] queryParams];
    [[RKClient sharedClient] post:[@"/common/photoscore.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        request.params = [RKParams paramsWithDictionary:@{@"uid":uid, @"pid":pid, @"submitupdate":@"true"}];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"score photo error: %@", [error description]);
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *d = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [d[@"error"] integerValue];
                if (code == 0) {
                    if (block) {
                        block();
                    }
//                    [SVProgressHUD showSuccessWithStatus:d[@"message"]];
                } else{
                    [SVProgressHUD showErrorWithStatus:d[@"message"]];
                }
                
   
            }
        }];
        
    }];
}

+ (void)scoreUserWithUid:(NSString*)uid block:(void(^)())block
{
    //    [SVProgressHUD show];
    NSMutableDictionary *dp = [[self class] queryParams];
    [[RKClient sharedClient] post:[@"/common/digouser.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        request.params = [RKParams paramsWithDictionary:@{@"uid":uid, @"submitupdate":@"true"}];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"score photo error: %@", [error description]);
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *d = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [d[@"error"] integerValue];
                if (code == 0) {
                    if (block) {
                        block();
                    }
                    //                    [SVProgressHUD showSuccessWithStatus:d[@"message"]];
                } else{
                    [SVProgressHUD showErrorWithStatus:d[@"message"]];
                }
                
                
            }
        }];
        
    }];
}

+ (void)uploadImage:(NSData*)data type:(NSString*)photoType block:(void(^)(NSDictionary *info))block
{
    NSMutableDictionary *dp = [[self class] queryParams];

    [[RKClient sharedClient] post:[@"/uc/uploadphoto.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){

        RKParams *p = [RKParams paramsWithDictionary:@{@"phototype":photoType}];
        [p setData:data MIMEType:@"image/png" forParam:@"Filedata"];
        request.params = p;
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"score photo error: %@", [error description]);
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *d = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [d[@"error"] integerValue];

                if (code == 0) {
                    if (block) {
                        block([d objectForKey:@"photoinfo"]);
                    }
                }
            }
        }];
        
    }];
}

@end
