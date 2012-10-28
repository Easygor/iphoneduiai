//
//  HZDegreePickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZDegreePickerView.h"

@interface HZDegreePickerView ()

@property (strong, nonatomic) NSArray *levels;
@property (strong, nonatomic) NSDictionary *degrees;
@property (strong, nonatomic) NSString *curDegree, *curLevel;

@end

@implementation HZDegreePickerView

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
        _levels = [[NSArray alloc] initWithObjects:@"中专或以下", @"大专", @"本科", @"双学士", @"硕士", @"博士", @"博士后", nil];
    }
    return _levels;
}

-(NSDictionary *)degrees
{
    if (_degrees == nil) {
        _degrees = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"中专或以下", @"2", @"大专",
                    @"3", @"本科", @"4", @"双学士", @"5", @"硕士", @"6", @"博士", @"7", @"博士后", nil];
    }
    
    return _degrees;
}

-(id)initWithDelegate:(id<HZDegreePickerDelegate>)delegate
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:2] retain];
    if (self) {
        self.delegate = delegate;
    }
    self.curDegree = [self.degrees objectForKey:[self.levels objectAtIndex:0]];
    self.curLevel = [self.levels objectAtIndex:0];
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
  
//    if([self.delegate respondsToSelector:@selector(dgreePickerDidChangeStatus:withNum:withDesc:)]) {
//        [self.delegate dgreePickerDidChangeStatus:self withNum:[self.degrees objectForKey:[self.levels objectAtIndex:row]] withDesc:[self.levels objectAtIndex:row]];
//    }
//    
    self.curDegree = [self.degrees objectForKey:[self.levels objectAtIndex:row]];
    self.curLevel = [self.levels objectAtIndex:row];
    
}
- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (IBAction)confirmAction:(id)sender
{
    // do some here
    if([self.delegate respondsToSelector:@selector(dgreePickerDidChangeStatus:withNum:withDesc:)]) {
        [self.delegate dgreePickerDidChangeStatus:self withNum:self.curDegree withDesc:self.curLevel];
    }
    [self dismiss];
}

@end
