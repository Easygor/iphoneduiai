//
//  UIImage+mergeImages.h
//  testMerge
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mergeImages)


+ (UIImage *)imageWithLeftNamed:(NSString *)leftImgName
                      bodyNamed:(NSString *)bodyImgName
                   rightImgName:(NSString *)rightImgName
                          width:(CGFloat)width;

//+ (UIImage *)imageWithLeftNamed:(NSString *)leftImgName
//                   rightImgName:(NSString *)rightImgName
//                          width:(CGFloat)width;


+ (UIImage *)imageNamed:(NSString *)imgName
                  width:(CGFloat)width;

@end
