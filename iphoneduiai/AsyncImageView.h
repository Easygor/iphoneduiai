//
//  AsyncImageView.h
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AsyncImageView : UIImageView

@property (nonatomic) BOOL showLoading;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

- (void) loadImage:(NSString*)imageURL;
- (void) loadImage:(NSString*)imageURL withBlock:(void(^)(void))block;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage withBlock:(void(^)(void))block;
+ (void) getImage:(NSString *)imageURL withBlock:(void(^)(UIImage *image))block;

- (void)clearImageAndRequest;

@end
