//
//  SettingViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPhotoView.h"
#import "AvatarView.h"
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate>

//@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) ShowPhotoView *showPhotoView;
@property (strong, nonatomic) AvatarView *avatarView;


@end
