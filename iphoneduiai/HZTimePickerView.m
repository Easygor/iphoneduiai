//
//  HZTimePickerView.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZTimePickerView.h"
@interface HZTimePickerView ()

@property (strong, nonatomic) NSArray *levels;
@property (strong, nonatomic) NSDictionary *degrees;

@end

@implementation HZTimePickerView
@synthesize degreePicker=_degreePicker;
@synthesize delegate=_delegate;
@synthesize levels=_levels, degrees=_degrees;

- (void)dealloc
{
    self.delegate = nil;
    [_levels release];
    [_degrees release];
    [_degreePicker release];
    [super dealloc];
}

-(NSArray *)levels
{
    if (_levels == nil) {
        _levels = [[NSArray alloc] initWithObjects:@"高中以下", @"高中", @"大专", @"本科", @"硕士", @"博士", nil];
    }
    return _levels;
}

-(NSDictionary *)degrees
{
    if (_degrees == nil) {
        _degrees = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"高中以下", @"1", @"高中", @"2", @"大专",
                    @"3", @"本科", @"4", @"硕士", @"5", @"博士", nil];
    }
    
    return _degrees;
}

-(id)initWithDelegate:(id<HZTimePickerDelegate>)delegate
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:2] retain];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - PickerView lifecycle

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.levels.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.levels objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"hahaha");
    
//    if([self.delegate respondsToSelector:@selector(dgreePickerDidChangeStatus:withNum:withDesc:)]) {
//        [self.delegate dgreePickerDidChangeStatus:self withNum:[self.degrees objectForKey:[self.levels objectAtIndex:row]]
//                                         withDesc:[self.levels objectAtIndex:row]];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(timePickerDidChangeStatus:withNum:withDesc:)]) {
//        [self.delegate timePickerDidChangeStatus:self withNum:[self.de] withDesc:<#(NSString *)#>]
//    }
    
}


@end
