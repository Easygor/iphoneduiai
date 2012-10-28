//
//  HZPopPickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZPopPickerView.h"

@interface HZPopPickerView ()

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *curLabel, *curDesc;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HZPopPickerView

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    [_curDesc release];
    [_curLabel release];
    [_data release];
    [_titleLabel release];
    [super dealloc];
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [[self.dataSource popPickerData:self] retain];
        self.titleLabel.text = [self.dataSource titleForPopPicker:self];
        if (_data.count > 0) {
            self.curDesc = _data[0][@"desc"];
            self.curLabel = _data[0][@"label"];
        }

    }
    
    return _data;
}

-(id)initWithDelegate:(id)delegate
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:3] retain];
    if (self) {
        self.delegate = delegate;
        self.dataSource = delegate;
    }
//    
//    self.data = [self.dataSource popPickerData:self];
//    self.titleLabel.text = [self.dataSource titleForPopPicker:self];

    
    return self;
    
}


#pragma mark - PickerView lifecycle

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.data.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.data[row][@"desc"];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.curDesc = self.data[row][@"desc"];
    self.curLabel = self.data[row][@"label"];
    
}
- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (IBAction)confirmAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popPickerDidChangeStatus:withLabel:withDesc:)]) {
        [self.delegate popPickerDidChangeStatus:self withLabel:self.curLabel withDesc:self.curDesc];
    }
    
    [self dismiss];
}

@end
