//
//  HZTimeSectionPickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-10.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZTimeSectionPickerView.h"

@interface HZTimeSectionPickerView ()

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation HZTimeSectionPickerView

- (void)dealloc
{
    self.delegate = nil;
    [_picker release];
    [super dealloc];
}

-(id)initTimeSection
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:6] retain];
    if (self) {
        self.curMaxDesc = @"24:00";
        self.curMinDesc = @"00:00";
        
        self.minNum = 0;
        self.maxNum = 24;
    }

    
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
        return [NSString stringWithFormat:@"%d:00", self.minNum+row];
    } else if (component == 1) {
        return [NSString stringWithFormat:@"%d:00", self.curMaxNum+row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            self.curMinNum = self.minNum + row;
            self.curMaxNum = self.curMinNum+1;
            [self.picker selectRow:0 inComponent:1 animated:YES];
            [self.picker reloadComponent:1];
            
            break;
        case 1:
            self.curMaxNum += row;
            
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
    if ([self.delegate respondsToSelector:@selector(timeSectionPickerDidChange:)]) {
        self.curMaxDesc = [NSString stringWithFormat:@"%d:00", self.curMaxNum];
        self.curMinDesc = [NSString stringWithFormat:@"%d:00", self.curMinNum];
        [self.delegate timeSectionPickerDidChange:self];
    }
    
    [self dismiss];
}

@end
