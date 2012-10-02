//
//  UserCardTableCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UserCardTableCell.h"
#import "Utils.h"

@interface UserCardTableCell ()

@property (strong, nonatomic) NSArray *arry;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel, *contentLabel;

@end

@implementation UserCardTableCell

- (void)dealloc
{
    [_arry release];
    [_timeLabel release];
    [_contentLabel release];
    [_leftCard release];
    [_middleCard release];
    [_rightCard release];
    [_users release];
    [super dealloc];
}

- (NSArray *)arry
{
    if (_arry == nil) {
        _arry = [[NSArray alloc] initWithArray:@[self.leftCard, self.middleCard, self.rightCard]];
    }
    
    return _arry;
}

- (void)setUsers:(NSArray *)users
{
    if (![_users isEqualToArray:users]) {
        _users = [users retain];
        
        for (int i=0; i< MIN(users.count, self.arry.count); i++) {
            UserCardView *view = [self.arry objectAtIndex:i];
            NSDictionary *user = [users objectAtIndex:i];
            view.hidden = NO;
            [view.imageView loadImage:[user objectForKey:@"photo"]];
            view.picNumLabel.text = [NSString stringWithFormat:@"%@P", [user objectForKey:@"photocount"]];
            view.infoLabel.text = [NSString stringWithFormat:@"%@ %@岁 %@cm",
                                   [Utils descriptionForDistance:[[user objectForKey:@"distance"] intValue]],
                                   [user objectForKey:@"age"], [user objectForKey:@"height"]];
        }
        
        for (int i=users.count; i<self.arry.count; i++) {
            UserCardView *view = [self.arry objectAtIndex:i];
            view.hidden = YES;
        }
    }
}

@end
