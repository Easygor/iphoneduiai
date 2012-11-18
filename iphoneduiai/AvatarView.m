//
//  AvatarView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AvatarView.h"

@interface AvatarView ()

@property (strong, nonatomic) IBOutlet UIImageView *sexView, *takePicView;
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation AvatarView

- (void)dealloc
{
    [_sex release];
    [_sexView release];
    [_imageView release];
    [super dealloc];
}

- (void)setSex:(NSString *)sex
{
    if (![_sex isEqualToString:sex]) {
        _sex = [sex retain];
        
        if ([sex isEqualToString:@"w"]) {
            self.sexView.image = [UIImage imageNamed:@"female_icon.png"];
        } else{
            self.sexView.image = [UIImage imageNamed:@"male_icon.png"];
        }
    }
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        
        if (editing) {
            self.sexView.hidden = YES;
            self.uploadBtn.hidden = NO;
            self.takePicView.hidden = NO;
        } else{
            self.sexView.hidden = NO;
            self.uploadBtn.hidden = YES;
            self.takePicView.hidden = YES;
        }
    }

}

@end
