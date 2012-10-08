//
//  RoundThumbView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundThumbView : UIView
@property (nonatomic) BOOL selected, editing;

- (id)initWithFrame:(CGRect)frame image:(NSString*)imageUrl target:(id)delegate forSelector:(SEL)gestureAction;

@end
