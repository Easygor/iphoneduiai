//
//  HZNumberPickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-16.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZNumberPickerView.h"

@implementation HZNumberPickerView

-(id)initWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:5] retain];
    if (self) {
        
    }
    
    self.curNum = self.minNum = minNum;
    self.maxNum = maxNum;
    
    return self;
    
}


#pragma mark - PickerView lifecycle

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.maxNum - self.minNum;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [NSString stringWithFormat:@"%d", self.minNum+row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.curNum = self.minNum + row;
}

- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (IBAction)confirmAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(numberPickerDidChange:)]) {
        [self.delegate numberPickerDidChange:self];
    }
    
    [self dismiss];
}

@end
