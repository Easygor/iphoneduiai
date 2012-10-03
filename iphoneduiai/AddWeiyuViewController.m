//
//  AddWeiyuViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-3.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AddWeiyuViewController.h"

@interface AddWeiyuViewController ()

@end

@implementation AddWeiyuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

@end
