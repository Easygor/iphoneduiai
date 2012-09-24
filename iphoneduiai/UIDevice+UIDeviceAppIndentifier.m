//
//  UIDevice+UIDeviceAppIndentifier.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-14.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UIDevice+UIDeviceAppIndentifier.h"

@implementation UIDevice (UIDeviceAppIndentifier)

- (NSString *) deviceApplicationIdentifier
{
    static NSString *name = @"theDeviceApplicationIdentifier";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey: name];
    
    if (!value)
    {
        value = (NSString *) CFUUIDCreateString (kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault));
        [defaults setObject: value forKey: name];
        [defaults synchronize];
    }
    return value;
}

@end
