//
//  BlockUserCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BlockUserCell.h"

@interface BlockUserCell ()

@property (strong, nonatomic) NSArray *arry;

@end

@implementation BlockUserCell


- (void)dealloc
{
    self.delegate = nil;
    [_arry release];
    [_leftCard release];
    [_middleCard release];
    [_rightCard release];
    [_users release];
    [super dealloc];
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(gestureAction:)] autorelease];
    UITapGestureRecognizer *tap2 = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(gestureAction:)] autorelease];
    UITapGestureRecognizer *tap3 = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(gestureAction:)] autorelease];
    [self.leftCard addGestureRecognizer:tap];
    [self.middleCard addGestureRecognizer:tap2];
    [self.rightCard addGestureRecognizer:tap3];
}

- (NSArray *)arry
{
    if (_arry == nil) {
        _arry = [[NSArray alloc] initWithArray:@[self.leftCard, self.middleCard, self.rightCard]];
    }
    
    return _arry;
}

- (void)setIsEditing:(BOOL)isEditing
{
    if (_isEditing != isEditing) {
        _isEditing = isEditing;
        
        for (UserCardView *view in self.arry) {
            UIView *delLogo = [view viewWithTag:1001];
            delLogo.hidden  = !isEditing;
        }

    }
}

- (void)setUsers:(NSArray *)users
{
    if (![_users isEqualToArray:users]) {
        _users = [users retain];
        
        for (int i=0; i< MIN(users.count, self.arry.count); i++) {
            UserCardView *view = [self.arry objectAtIndex:i];
            NSDictionary *user = [users objectAtIndex:i];
            view.hidden = NO;
            
            if ([user[@"photo"] isEqualToString:@""]) {
                [view.imageView loadImage:DEFAULTAVATAR];
            } else{
                [view.imageView loadImage:user[@"photo"]];
            }
            
            UIImage *img = [UIImage imageNamed:@"mailapp_delBtn"];
            UIImageView *delLogo = [[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-img.size.width, 0, img.size.width, img.size.height)] autorelease];
            delLogo.image = img;
            delLogo.tag = 1001;
            delLogo.hidden = YES;
            [view addSubview:delLogo];
            
            view.picNumLabel.hidden = YES;
            view.infoLabel.hidden = YES;
        }
        
        for (int i=users.count; i<self.arry.count; i++) {
            UserCardView *view = [self.arry objectAtIndex:i];
            view.hidden = YES;
        }
    }
}

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateBegan) {
        // something
        
        CGSize size = gesture.view.frame.size;
        UIView *coverView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
        coverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.35);
        [gesture.view addSubview:coverView];
        
        //        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [coverView removeFromSuperview];
        });
        
        NSString *pos = [NSString stringWithFormat:@"%d", [self.arry indexOfObject:gesture.view]];
        
        if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
            [self.delegate didChangeStatus:self toStatus:pos];
        }
    }
}


@end
