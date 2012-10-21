//
//  SettingViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPhotoView.h"

@interface SettingViewController : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) ShowPhotoView *showPhotoView;


@end
