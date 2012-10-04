//
//  ConditionViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ConditionViewController.h"
#import "HZSementedControl.h"

@interface ConditionViewController () <HZSementdControlDelegate>
@property (retain, nonatomic) IBOutlet HZSementedControl *sementedControl;

@end

@implementation ConditionViewController

- (void)dealloc
{
    [_sementedControl release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setSementedControl:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}


#pragma mark - delegate sememnted 
- (void)didChange:(HZSementedControl *)segment atIndex:(NSInteger)index forValue:(NSString *)text
{
    if ([segment isEqual:self.sementedControl]) {
        NSLog(@"selected index: %d, text: %@", index, text);
    }
}

@end
