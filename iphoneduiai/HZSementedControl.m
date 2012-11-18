//
//  HZSementedControl.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-10.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZSementedControl.h"

@interface HZSementedControl ()

@property (strong, nonatomic) NSArray *controls;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation HZSementedControl

@synthesize controls=_controls;
@synthesize currentIndex=_currentIndex;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.delegate = nil;
    [_controls release];
    [super dealloc];
}

- (NSArray *)controls
{
    if (_controls == nil) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (UIButton *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [tmp addObject:btn];
            }
        }
        
        _controls = [[NSArray alloc] initWithArray:tmp];
    }
    
    return _controls;
}

- (IBAction)btnAction:(UIButton *)btn
{
    for (UIButton *b in self.controls) {
        if ([b isEqual:btn]) {
            b.selected = YES;
            b.enabled = NO;
            b.backgroundColor = [UIColor whiteColor];
        } else{
            b.selected = NO;
            b.enabled = YES;
            b.backgroundColor = RGBCOLOR(238, 238, 238);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didChange:atIndex:forValue:)]) {
        [self.delegate didChange:self atIndex:[self.controls indexOfObject:btn] forValue:btn.titleLabel.text];
    }
}

-(void)selectSegmentAtIndex:(NSInteger)index
{
    if (index > self.controls.count) {
        [self btnAction:nil];
    } else{
        [self btnAction:[self.controls objectAtIndex:index]];
    }
}
@end
