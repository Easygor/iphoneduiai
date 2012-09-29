//
//  NSString+Date.m
//  kjfang
//
//  Created by Cloud Dai on 12-9-21.
//  Copyright (c) 2012年 kajiefang.com. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

// add by @cloud_dai 2012-09-21
- (NSDate*)datePatternForString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: self];
    
    NSDate *myDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    return myDate;
}

@end
