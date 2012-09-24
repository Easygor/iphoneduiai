//
//  HZTabBar.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZTabBar.h"

#define ARROW_IMAGE_TAG 2394859

@interface HZTabBar(PrivateMethods)

-(UIButton*)createButton:(int)i width:(float)width;

-(UIImage*)doImageMask:(UIImage*)upImage size:(CGSize)targetSize downImage:(UIImage*)downImage;

-(UIImage*) createDownImage:(CGSize)size downImage:(UIImage*)downImage;

-(UIImage*) fillImageWhite:(UIImage*)originImage;

- (UIImage*) selectedItemImage;

-(void) dimAllButtonsExcept:(UIButton*)selectedButton;

- (void) addArrowAtIndex:(NSUInteger)itemIndex;

@end

@implementation HZTabBar

@synthesize buttons,itemImages,height;

-(void)dealloc{
    
    [buttons release];
    
    [itemImages release];
    
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithImages:(NSArray*)images delegate:(NSObject <HZTabBarDelegate>*)myDelegate

{
    
    if (self = [super init])
        
    {
        
        itemImages=[[NSMutableArray alloc]initWithArray:images];
        
        delegate = myDelegate;
        
        CGRect rect=[[UIScreen mainScreen] bounds];
        
        width=rect.size.width;
        
        UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
        
        height=topImage.size.height*2;
        
        //==================开始core graphic绘图===================
        
        // 初始化上下文
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
        
        // 原图2x22，拉伸为320x22，帽宽、高为0
        
        UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        
        [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
        
        // tab bar的下半部分是黑色，设置为当前上下文的填充色和边框色为黑色，然后填充tab bar下半部分
        
        [[UIColor blackColor] set];
        
        CGContextFillRect(UIGraphicsGetCurrentContext(),CGRectMake(0, topImage.size.height, width, topImage.size.height));
        
        // 将当前绘制的内容设置为背景图
        
        UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //====================绘图结束====================
        
        UIImageView* backgroundImageView =[[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        
        backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        [self addSubview:backgroundImageView];
        
        self.frame = backgroundImageView.frame;
        
        self.buttons = [[NSMutableArray alloc] initWithCapacity:images.count];
        
        CGFloat offsetX = 0;
        
        for (NSUInteger i = 0 ; i < itemImages.count ; i++)
            
        {
            
            float itemWidth=self.frame.size.width/itemImages.count;
            
            //生成tab bar的按钮
            
            UIButton* button = [self createButton:i width:itemWidth];
            
            //添加action
            
            [button addTarget:self action:@selector(touchUpInsideAction:)forControlEvents:UIControlEventTouchUpInside];
            
            [buttons addObject:button];
            
            //重设按钮的 x 坐标
            
            button.frame = CGRectMake(offsetX, 0.0, button.frame.size.width, button.frame.size.height);
            
            [self addSubview:button];
            
            //Advance the horizontal offset
            
            offsetX += itemWidth;
            
        }
        
    }
    
    return self;
    
}

-(UIButton*)createButton:(int)i width:(float)_width{
    
    // 创建合适大小的UIButton
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0.0, 0.0, _width, self.frame.size.height);
    
    // 从itemImage中获取按钮图片
    
    UIImage* rawButtonImage = [UIImage imageNamed:[itemImages objectAtIndex:i]];
    
    // 将rawButtonImage与backgroundImage合成一张图片。backgroudImage为空时，制造一张灰色图片
    
    UIImage* buttonImage = [self doImageMask:rawButtonImage size:button.frame.size downImage:nil];
    
    // backgroudImage不为空，将制造一张rawButtonImage与backgroundImage通过Mask合成的图片
    
    UIImage* buttonPressedImage = [self doImageMask:rawButtonImage size:button.frame.size downImage:[UIImage imageNamed:@"TabBarItemSelectedBackground.png"]];
    
    // 将上述两张合成图片作为按钮的Normal和Select状态时的图片
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    [button setImage:buttonPressedImage forState:UIControlStateSelected];
    
    // 设置按钮两个状态时的背景图
    
    [button setBackgroundImage:[self selectedItemImage] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[self selectedItemImage] forState:UIControlStateSelected];
    
    button.adjustsImageWhenHighlighted =NO;// 当为YES时，按钮按下时会自动变暗。
    
    return button;
    
}

// 使用遮罩技术，将两张图片进行合成

-(UIImage*)doImageMask:(UIImage*)upImage size:(CGSize)targetSize downImage:(UIImage*)downImage

{
    
    // 选中时，背景为蓝色，未选中时，背景为灰色
    
    UIImage* backgroundImage = [self createDownImage:upImage.size downImage:downImage];
    
    // 将上层图片转换为白色背景黑色前景（用于做遮罩）
    
    UIImage* bwImage = [self fillImageWhite:upImage];
    
    // 用黑白两色的upImage图片创建一个遮罩
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                             
                                             CGImageGetHeight(bwImage.CGImage),
                                             
                                             CGImageGetBitsPerComponent(bwImage.CGImage),
                                             
                                             CGImageGetBitsPerPixel(bwImage.CGImage),
                                             
                                             CGImageGetBytesPerRow(bwImage.CGImage),
                                             
                                             CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    
    // 用这个遮罩和下层图片合成按钮图片
    
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
    
    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:upImage.scale
                            
                                         orientation:upImage.imageOrientation];
    
    // Cleanup
    
    CGImageRelease(imageMask);
    
    CGImageRelease(tabBarImageRef);
    
    // ==============重新开始绘制按钮图片==============
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    // 将按钮图片绘制在targetSize的中心对齐
    
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (upImage.size.width/2.0),
                                       
                                       (targetSize.height/2.0) - (upImage.size.height/2.0),
                                       
                                       upImage.size.width,
                                       
                                       upImage.size.height)];
    
    // 将绘制的图片返回
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

// 创建背景图片

-(UIImage*) createDownImage:(CGSize)size downImage:(UIImage*)downImage

{
    
    //=================开始 Core Graphics 绘图=================
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    if (downImage)//如果使用了背景图片，说明是选中状态，绘制背景图片（即TabBarItemSelectedBackground.png）
        
    {
        
        // 在上层图片的中心对齐绘制背景图片
        
        [downImage drawInRect:CGRectMake((size.width - CGImageGetWidth(downImage.CGImage)) / 2,
                                        
                                        (size.height - CGImageGetHeight(downImage.CGImage)) / 2,
                                        
                                        CGImageGetWidth(downImage.CGImage),
                                        
                                        CGImageGetHeight(downImage.CGImage))];
        
    }
    
    else// 否则为为选中状态，绘制一个灰色填充的矩形
        
    {
        
        [[UIColor lightGrayColor] set];
        
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
    }
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //===================结束绘图===================
    
    return result;
    
}

// 将图片设置为白色背景，方便做遮罩

-(UIImage*) fillImageWhite:(UIImage*)originImage

{
    
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(originImage.CGImage), CGImageGetHeight(originImage.CGImage));
    
    // 创建位图上下文
    
    CGContextRef context = CGBitmapContextCreate(NULL, // 内存图片数据
                                                 
                                                 imageRect.size.width, // 宽
                                                 
                                                 imageRect.size.height, // 高
                                                 
                                                 8, // 色深
                                                 
                                                 0, // 每行字节数
                                                 
                                                 CGImageGetColorSpace(originImage.CGImage), // 颜色空间
                                                 
                                                 kCGImageAlphaPremultipliedLast);// alpha通道，RBGA
    
    // 设置当前上下文填充色为白色（RGBA值）
    
    CGContextSetRGBFillColor(context,1,1,1,1);
    
    CGContextFillRect(context,imageRect);
    
    // 用 originImage 作为 clipping mask（选区）
    
    CGContextClipToMask(context,imageRect, originImage.CGImage);
    
    // 设置当前填充色为黑色
    
    CGContextSetRGBFillColor(context,0, 0, 0, 1);
    
    // 在clipping mask上填充黑色
    
    CGContextFillRect(context,imageRect);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:originImage.scale orientation:originImage.imageOrientation];
    
    // Cleanup
    
    CGContextRelease(context);
    
    CGImageRelease(newCGImage);
    
    return newImage;
    
}

// 绘制按钮选中时的背景图片

- (UIImage*) selectedItemImage

{
    
    // 用TabBarGradient 图片的高度计算背景图高度
    
    UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    
    CGSize tabBarItemSize = CGSizeMake(self.frame.size.width/itemImages.count, tabBarGradient.size.height*2);
    
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    // 创建带圆角的的拉伸图，即左右4个像素的圆角是不用拉伸的
    
    [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0]
     
     drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)]; // 绘图区域下移4像素
    
    // 返回拉伸图
    
    UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return selectedItemImage;
    
}

- (void)touchUpInsideAction:(UIButton*)button

{
    
    [self dimAllButtonsExcept:button];
    
    if (delegate!=nil && [delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        
        [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
    
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton

{
    
    for (UIButton* button in buttons)
        
    {
        
        if (button == selectedButton)
            
        {
            
            button.selected = YES;
            
            button.highlighted = button.selected ? NO : YES;
            
            //锦上添花的功能：在选中的按钮上方显示一个小箭头
            
            UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:ARROW_IMAGE_TAG];
            
            NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
            
            if (tabBarArrow)
                
            {//使用动画将小箭头移动至合适位置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:0.2];
                
                CGRect frame = tabBarArrow.frame;
                
                frame.origin.x = button.center.x;
                
                tabBarArrow.frame = frame;
                
                [UIView commitAnimations];
                
            }
            
            else
                
            {
                
                [self addArrowAtIndex:selectedIndex];
                
            }
            
        }
        
        else
            
        {
            
            button.selected = NO;
            
            button.highlighted = NO;
            
        }
        
    }
    
}

// 在选定按钮上加一个箭头

- (void) addArrowAtIndex:(NSUInteger)itemIndex

{
    
    UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple.png"];
    
    UIImageView* tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
    
    tabBarArrow.tag = ARROW_IMAGE_TAG;
    
    // 箭头将位于按钮上方并稍微下移2个像素的位置
    
    CGFloat y = -tabBarArrowImage.size.height + 2;
    
    // 箭头x坐标将和按钮的中心x坐标对齐
    
    UIButton* btn=[buttons objectAtIndex:itemIndex];
    
    CGFloat x= btn.center.x;
    
    tabBarArrow.frame = CGRectMake(x, y,tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    
    [self addSubview:tabBarArrow];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
