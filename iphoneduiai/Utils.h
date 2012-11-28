//
//  Utils.h
//  WhoHelp
//
//  Created by cloud on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils : NSObject

+ (void)helpNotificationForTitle: (NSString *)title forMessage: (NSString *)message;
+ (void)errorNotification:(NSString *)message;
+ (void)warningNotification:(NSString *)message;
+ (void)tellNotification:(NSString *)message;

+ (NSString *)descriptionForTime:(NSDate *)date;
+ (NSString *)descriptionForDistance:(NSInteger)d;

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
+ (NSString *)genRandStringLength:(int)len;
+(float)distanceFrom:(CLLocationCoordinate2D)posA to:(CLLocationCoordinate2D)posB;

+ (NSString *)curDateParam;
+ (NSString *)dateDescWithDate:(NSDate*)date;
+ (NSMutableDictionary*)queryParams;
+ (void)scorePhotoWithUid:(NSString*)uid pid:(NSString*)pid block:(void(^)())block;
+ (void)uploadImage:(NSData*)data type:(NSString*)photoType block:(void(^)(NSMutableDictionary *info))block;
+ (void)scoreUserWithUid:(NSString*)uid block:(void(^)())block;
+ (void)deleteImage:(NSString*)pid block:(void(^)())block;

+ (UIImage *)getImageFrom:(UIImage*)srcimg withRect:(CGRect)rect;
+ (UIImage*)cutImageFrom:(UIImage*)scrimg;
+ (UIImage*)thubImageFrom:(UIImage*)scrimg;
@end
