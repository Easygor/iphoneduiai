//
//  MarrayReqView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MarrayReqView.h"

#define INIH 38

@interface MarrayReqView ()

@property (strong, nonatomic) IBOutlet UILabel *sexLabel, *ageLabel, *areaLabel, *heightLabel, *degreeLabel, *houseLabel, *carLabel;

@end

@implementation MarrayReqView

- (void)dealloc
{
    [_sexLabel release];
    [_ageLabel release];
    [_areaLabel release];
    [_heightLabel release];
    [_degreeLabel release];
    [_houseLabel release];
    [_carLabel release];
    [super dealloc];
}

- (void)setMarrayReq:(NSDictionary *)marrayReq
{
    if (![_marrayReq isEqualToDictionary:marrayReq]) {
        _marrayReq = [marrayReq retain];
        self.sexLabel.text = [marrayReq objectForKey:@"sex"];
        self.areaLabel.text = [NSString stringWithFormat:@"%@ %@", [marrayReq objectForKey:@"province"], [marrayReq objectForKey:@"city"]];
        self.heightLabel.text = [NSString stringWithFormat:@"%@~%@cm", [marrayReq objectForKey:@"minheight"], [marrayReq objectForKey:@"maxheight"]];
        self.ageLabel.text = [NSString stringWithFormat:@"%@~%@岁", [marrayReq objectForKey:@"minage"], [marrayReq objectForKey:@"maxage"]];
        self.degreeLabel.text = [marrayReq objectForKey:@"degree"];
        self.houseLabel.text = [marrayReq objectForKey:@"house"];
        self.carLabel.text = [marrayReq objectForKey:@"auto"];
    }
}

- (void)showMeInView:(UIView *)view atPoint:(CGPoint)pos animated:(BOOL)animated
{
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = pos.x;
    selfFrame.origin.y = pos.y;
    
    if (animated) {
        
        self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, INIH);;
        [view addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, selfFrame.size.height);
        }];
        
    } else{
        self.frame = selfFrame;
        [view addSubview:self];
    }
}

- (void)removeMeWithAnimated:(BOOL)animated
{
    
    CGRect selfFrame = self.frame;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, INIH);
                         } completion:^(BOOL finshed){
                             [self removeFromSuperview];
                             self.frame = selfFrame;
                         }];
    } else{
        [self removeFromSuperview];
    }
}

@end
