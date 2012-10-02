//
//  CustomCellDelegate.h
//  cosmetics
//
//  Created by Cloud Dai on 12-9-26.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CustomCellDelegate <NSObject>

@optional
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString*)status;

@end
