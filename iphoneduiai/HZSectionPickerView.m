//
//  HZSectionPickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZSectionPickerView.h"

@interface HZSectionPickerView ()

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation HZSectionPickerView

- (void)dealloc
{
    self.delegate = nil;
    [_picker release];
    [_titleLabel release];
    [super dealloc];
}

-(id)initWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:4] retain];
    if (self) {
        
    }
    
    self.curMinNum = self.minNum = minNum;
    self.curMaxNum = self.maxNum = maxNum;
    
    return self;
    
}


#pragma mark - PickerView lifecycle

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.maxNum - self.minNum;
    } else{
        return self.maxNum - self.curMinNum;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", self.minNum+row];
    } else if (component == 1) {
        return [NSString stringWithFormat:@"%d", self.curMinNum+row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            self.curMinNum = self.minNum + row;
            [self.picker selectRow:0 inComponent:1 animated:YES];
            [self.picker reloadComponent:1];
            
            break;
        case 1:
            self.curMaxNum = self.curMinNum + row;

            break;
        default:
            break;
    }
}

- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (IBAction)confirmAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(sectionPickerDidChange:)]) {
        [self.delegate sectionPickerDidChange:self];
    }
    
    [self dismiss];
}

@end
