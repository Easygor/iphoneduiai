//
//  AddWeiyuViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-3.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AddWeiyuViewController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITextView *contentTextView;
    UILabel* contentLabel;
    UIView *contentView;
    UIView* toolView;
    
    UIButton *faceButton;
    
    AsyncImageView *avatarImageView;
    
}

@end
