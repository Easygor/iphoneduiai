//
//  ConditionViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *conditions;

@property(strong,nonatomic)IBOutlet  UIView *idView;
@property(strong,nonatomic)IBOutlet UIView *conditionView;



-(IBAction)conditionChange:(id)sender;
@end
