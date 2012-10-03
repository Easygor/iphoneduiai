//
//  AsyncImageView.h
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AsyncImageView : UIImageView

- (void) loadImage:(NSString*)imageURL;
- (void) loadImage:(NSString*)imageURL withBlock:(void(^)(void))block;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage withBlock:(void(^)(void))block;


@end
