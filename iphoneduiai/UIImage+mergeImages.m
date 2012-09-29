//
//  UIImage+mergeImages.m
//  testMerge
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UIImage+mergeImages.h"

@implementation UIImage (mergeImages)

+ (UIImage *)imageWithLeftNamed:(NSString *)leftImgName
                      bodyNamed:(NSString *)bodyImgName
                   rightImgName:(NSString *)rightImgName
                          width:(CGFloat)width
{
    
    UIImage *lImg = [UIImage imageNamed:leftImgName];
    UIImage *rImg = [UIImage imageNamed:rightImgName];
    UIImage *bodyImg = [UIImage imageNamed:bodyImgName];
    CGFloat height = lImg.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [lImg drawInRect:CGRectMake(0, 0, lImg.size.width, height)];
    [rImg drawInRect:CGRectMake(width-rImg.size.width, 0, rImg.size.width, height)];
    UIImage *stretchedImg = [bodyImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    [stretchedImg drawInRect:CGRectMake(lImg.size.width, 0, width-lImg.size.width-rImg.size.width, height)];
    
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return bgImg;
}

//+ (UIImage *)imageWithLeftNamed:(NSString *)leftImgName
//                   rightImgName:(NSString *)rightImgName
//                          width:(CGFloat)width
//{
//    UIImage *lImg = [UIImage imageNamed:leftImgName];
//    UIImage *rImg = [UIImage imageNamed:rightImgName];
//    CGFloat height = lImg.size.height;
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
//    UIImage *stretchedImg = [lImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    [stretchedImg drawInRect:CGRectMake(0, 0, width-rImg.size.width, height)];
//    [rImg drawInRect:CGRectMake(width-rImg.size.width, 0, rImg.size.width, height)];
//    
//    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return bgImg;
//}

+ (UIImage *)imageNamed:(NSString *)imgName
                          width:(CGFloat)width
{
    UIImage *img = [UIImage imageNamed:imgName];
    CGFloat height = img.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    UIImage *stretchedImg = [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedImg drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return bgImg;
}

@end
