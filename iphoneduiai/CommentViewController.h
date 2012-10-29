//
//  CommentViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-26.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentViewController : UIViewController
{

    UITextField *commentField;
    UIButton *sendButton;
    NSString  *idStr;

}
@property (strong, nonatomic) NSString *idStr;
@property(nonatomic,retain) UITextView *contentView;
@property(nonatomic,retain) UIView *toolView;
@property(nonatomic,retain) UIView *bgView;


@end
