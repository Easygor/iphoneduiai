//
//  WeiTalkListViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiTalkListViewController : UITableViewController<UITextViewDelegate>
{
    // bottom bar
    UIImageView* textBackImageView;
    UIImageView* bottomBarView;
    UITextView* commentTextView;
    UIButton* postButton;
    NSString* commentString;
    BOOL isCommentTextViewEditing;
    
    // bottom bar button
    UIImageView* editImageView;
    UILabel* noticeLabel;
    UIButton* praiseButton;
    UIButton* forwardButton;

}
@property(nonatomic,strong) UIImageView* bottomBarView;
@end
