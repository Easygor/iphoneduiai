//
//  SendSuggestViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendSuggestViewController : UIViewController<UITextViewDelegate>
{
    UITextView  *contentTextView;
    UILabel *contentLabel;
}

@end
