//
//  HZLocation.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZLocation.h"

@implementation HZLocation

@synthesize country = _country;
@synthesize state = _state;
@synthesize city = _city;
@synthesize district = _district;
@synthesize street = _street;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize stateId=_stateId, areaId=_areaId, cityId=_cityId;

-(void)plusState:(NSDictionary *)state
{
    self.state = [state objectForKey:@"state"];
    self.stateId = [[state objectForKey:@"id"] integerValue];
}

-(void)plusCity:(NSDictionary *)city
{
    self.city = [city objectForKey:@"city"];
    self.cityId = [[city objectForKey:@"id"] integerValue];
}

-(void)plusArea:(NSDictionary *)area
{
    if (area) {
        self.district = [area objectForKey:@"area"];
    }else{
        self.district = @"";
    }
    self.areaId = [[area objectForKey:@"id"] integerValue];
}

-(NSDictionary *)toDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInteger: self.stateId], @"stateId",
            self.state, @"state",
            [NSNumber numberWithInteger: self.stateId], @"cityId",
            self.city, @"city",
     [NSNumber numberWithInteger: self.areaId], @"areaId",
            self.district, @"area",
            nil];
}

-(void)fromDictionary:(NSDictionary *)d
{
    self.state = [d objectForKey:@"state"];
    self.stateId = [[d objectForKey:@"stateId"] integerValue];
    self.city = [d objectForKey:@"city"];
    self.cityId = [[d objectForKey:@"cityId"] integerValue];
    if ([d objectForKey:@"area"]) {
        self.district = [d objectForKey:@"area"];
    }else{
        self.district = @"";
    }
    self.areaId = [[d objectForKey:@"areaId"] integerValue];
}

@end
