//
//  User.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-25.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZLocation.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSDate *lastTime, *created;
@property (nonatomic) NSInteger lastTimeInterval, createdInterval;
@property (strong, nonatomic) NSString *areaId, *provinceId, *cityId, *nation;
@property (strong, nonatomic) HZLocation *location;
@property (strong, nonatomic) NSArray *postion;
@property (nonatomic) NSInteger age;
@property (nonatomic) BOOL haveCar, haveChildren, haveHouse, marriaged;
@property (strong, nonatomic) NSString *booldtype;
@property (strong, nonatomic) NSString *constellationCode;
@property (nonatomic) NSInteger height;
@property (strong, nonatomic) NSString *careerCode;
@property (nonatomic) NSInteger nationCode;
@property (nonatomic) NSInteger yearNum, monthNum, dayNum;
@property (strong, nonatomic) NSString *zodiac;
@property (nonatomic) NSInteger viewCount, itegral, viplevel;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *avatar;
@property (nonatomic) NSInteger income;
@property (nonatomic) NSInteger degreeCode;
@property (strong, nonatomic) NSString *nickname;
@property (nonatomic) NSInteger distance;
@property (nonatomic) NSInteger photocount;

@end
