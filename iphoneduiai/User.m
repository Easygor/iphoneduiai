//
//  User.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-25.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "User.h"

@implementation User

- (void)dealloc
{
    [_uid release];
    [_lastTime release];
    [_created release];
    [_areaId release];
    [_provinceId release];
    [_cityId release];
    [_nation release];
    [_location release];
    [_postion release];
    [_booldtype release];
    [_constellationCode release];
    [_careerCode release];
    [_zodiac release];
    [_sex release];
    [_avatar release];
    [_nickname release];
    [super dealloc];
}

- (void)setCreatedInterval:(NSInteger)createdInterval
{
    if (_createdInterval != createdInterval) {
        _createdInterval = createdInterval;
        self.created = [NSDate dateWithTimeIntervalSince1970:createdInterval];
    }
}

- (void)setLastTimeInterval:(NSInteger)lastTimeInterval
{
    if (_lastTimeInterval != lastTimeInterval) {
        _lastTimeInterval = lastTimeInterval;
        self.lastTime = [NSDate dateWithTimeIntervalSince1970:lastTimeInterval];
    }
}

@end
