//
//  AddPicViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-6.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BJGridItem.h"

@interface AddPicViewController : UIViewController<UIScrollViewDelegate,BJGridItemDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *gridItems;
    BJGridItem *addbutton;
    BJGridItem *preGridItem;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    UITapGestureRecognizer *singletap;
    UIImage * curImg;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
- (void)Addbutton;

@end
