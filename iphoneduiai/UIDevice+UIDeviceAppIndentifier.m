//
//  UIDevice+UIDeviceAppIndentifier.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-14.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UIDevice+UIDeviceAppIndentifier.h"
#import "SSKeychain.h"
static NSString *name = @"theDeviceApplicationIdentifier";

@implementation UIDevice (UIDeviceAppIndentifier)

- (NSString *) deviceApplicationIdentifier
{
    
    NSError *error = nil;
    NSString *uuid = [SSKeychain passwordForService:name account:@"uuid" error:&error];
    
    if (!uuid)
    {
        uuid = (NSString *) CFUUIDCreateString (kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault));
       [SSKeychain setPassword:uuid forService:name account:@"uuid"];
    }
    
    return uuid;
    
}

@end
