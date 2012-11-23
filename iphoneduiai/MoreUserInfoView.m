//
//  MoreUserInfoView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MoreUserInfoView.h"
#define INIH 38

@interface MoreUserInfoView ()

@property (retain, nonatomic) IBOutlet UILabel *homeLabel;
@property (retain, nonatomic) IBOutlet UILabel *loveLocationLabel;
@property (retain, nonatomic) IBOutlet UILabel *marriageLabel;
@property (retain, nonatomic) IBOutlet UILabel *autoLabel;
@property (retain, nonatomic) IBOutlet UILabel *houseLabel;
@property (retain, nonatomic) IBOutlet UILabel *smokeTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *mostCostLabel;
@property (retain, nonatomic) IBOutlet UILabel *bestParLabel;
@property (retain, nonatomic) IBOutlet UILabel *drinkTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *beliefLabel;
@property (retain, nonatomic) IBOutlet UILabel *liveCustLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *rankConditionLabel;
@property (retain, nonatomic) IBOutlet UILabel *schoolLabel;
@property (retain, nonatomic) IBOutlet UILabel *specialityLabel;
@property (retain, nonatomic) IBOutlet UILabel *paihangLabel;
@property (retain, nonatomic) IBOutlet UILabel *parentTogetherLabel;
@property (retain, nonatomic) IBOutlet UILabel *childWantLabel;
@property (retain, nonatomic) IBOutlet UILabel *nationLabel;
@property (retain, nonatomic) IBOutlet UILabel *bloodTypeLabel;

@end

@implementation MoreUserInfoView

- (void)dealloc
{

    [_homeLabel release];
    [_loveLocationLabel release];
    [_marriageLabel release];
    [_autoLabel release];
    [_houseLabel release];
    [_smokeTypeLabel release];
    [_mostCostLabel release];
    [_bestParLabel release];
    [_drinkTypeLabel release];
    [_beliefLabel release];
    [_liveCustLabel release];
    [_companyNameLabel release];
    [_rankConditionLabel release];
    [_schoolLabel release];
    [_specialityLabel release];
    [_paihangLabel release];
    [_parentTogetherLabel release];
    [_childWantLabel release];
    [_nationLabel release];
    [_bloodTypeLabel release];
    [super dealloc];
}

- (void)setMoreUserInfo:(NSDictionary *)moreUserInfo
{
    if (![_moreUserInfo isEqualToDictionary:moreUserInfo]) {
        _moreUserInfo = [moreUserInfo retain];
        
        if (moreUserInfo[@"home_location"] && moreUserInfo[@"home_sublocation"]) {
            self.homeLabel.text = [NSString stringWithFormat:@"%@ %@", moreUserInfo[@"home_location"][@"valdata"], moreUserInfo[@"home_sublocation"][@"valdata"]];
        } else{
            self.homeLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"love_location"] && moreUserInfo[@"love_sublocation"]) {
            self.loveLocationLabel.text = [NSString stringWithFormat:@"%@ %@", moreUserInfo[@"love_location"][@"valdata"], moreUserInfo[@"love_sublocation"][@"valdata"]];
        } else{
            self.loveLocationLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"marriage"]) {
            self.marriageLabel.text = moreUserInfo[@"marriage"][@"valdata"];
        } else{
            self.marriageLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"auto"]) {
            self.autoLabel.text = moreUserInfo[@"auto"][@"valdata"];
        } else{
            self.autoLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"house"]) {
            self.houseLabel.text = moreUserInfo[@"house"][@"valdata"];
        } else{
            self.houseLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"smoke_type"]) {
            self.smokeTypeLabel.text = moreUserInfo[@"smoke_type"][@"valdata"];
        } else{
            self.smokeTypeLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"most_cost"]) {
            self.mostCostLabel.text = moreUserInfo[@"most_cost"][@"valdata"];
        } else{
            self.mostCostLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"best_par"]) {
            self.bestParLabel.text = moreUserInfo[@"best_par"][@"valdata"];
        } else{
            self.bestParLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"drink_type"]) {
            self.drinkTypeLabel.text = moreUserInfo[@"drink_type"][@"valdata"];
        } else{
            self.drinkTypeLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"belief"]) {
            self.beliefLabel.text = moreUserInfo[@"belief"][@"valdata"];
        } else{
            self.beliefLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"live_cust"]) {
            self.liveCustLabel.text = moreUserInfo[@"live_cust"][@"valdata"];
        } else{
            self.liveCustLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"company_name"]) {
            self.companyNameLabel.text = moreUserInfo[@"company_name"][@"val"];
        } else{
            self.companyNameLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"rank_condition"]) {
            self.rankConditionLabel.text = moreUserInfo[@"rank_condition"][@"valdata"];
        } else{
            self.rankConditionLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"university"]) {
            self.schoolLabel.text = moreUserInfo[@"university"][@"val"];
        } else{
            self.schoolLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"speciality"]) {
            self.specialityLabel.text = moreUserInfo[@"speciality"][@"valdata"];
        } else{
            self.specialityLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"paihang"]) {
            self.paihangLabel.text = moreUserInfo[@"paihang"][@"valdata"];
        } else{
            self.paihangLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"parent_together"]) {
            self.parentTogetherLabel.text = moreUserInfo[@"parent_together"][@"valdata"];
        } else{
            self.parentTogetherLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"child_want"]) {
            self.childWantLabel.text = moreUserInfo[@"child_want"][@"valdata"];
        } else{
            self.childWantLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"nation"]) {
            self.nationLabel.text = moreUserInfo[@"nation"][@"valdata"];
        } else{
            self.nationLabel.text = @"未填写";
        }
        
        if (moreUserInfo[@"blood_type"]) {
            self.bloodTypeLabel.text = moreUserInfo[@"blood_type"][@"valdata"];
        } else{
            self.bloodTypeLabel.text = @"未填写";
        }
        
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
