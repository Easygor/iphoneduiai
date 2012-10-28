//
//  CustomBarButtonItem.h
//  WhoHelp
//
//  Created by Dai Cloud on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBarButtonItem : UIBarButtonItem


-(id)initBackBarButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)action;
-(id)initRightBarButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)action;
-(id)initBarButtonWithImage:(UIImage *)image  target:(id)target action:(SEL)action;

+ titleForNavigationItem:(NSString*)title;
@end
