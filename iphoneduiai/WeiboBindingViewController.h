//
//  WeiboBindingViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "TCWBEngine.h"
@interface WeiboBindingViewController : UIViewController<SinaWeiboDelegate>

{
    TCWBEngine *weiboEngine;
}
@property (nonatomic, retain) TCWBEngine   *weiboEngine;
@end
