//
//  SetEmailViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SetEmailViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    UITextField *emailField;
}

@end
