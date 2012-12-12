//
//  BJGridItem.m
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BJGridItem.h"

@implementation BJGridItem
@synthesize isEditing,isRemovable,index;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImg:(UIImage *)image
{
//    normalImage = image;
    bgImageView.image = image;
//    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
}

- (void)setImgWithName:(NSString*)imageName
{
    if ([imageName hasPrefix:@"http://"]) {
        [bgImageView loadImage:imageName];
    } else{
        bgImageView.image = [UIImage imageNamed:imageName];
    }
}

- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable {
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        normalImage = [UIImage imageNamed:imageName];
        titleText = title;
        self.isEditing = NO;
        index = aIndex;
        self.isRemovable = removable;
        
        bgImageView = [[[AsyncImageView alloc] initWithFrame:self.bounds] autorelease];
        [self setImgWithName:imageName];
        [self addSubview:bgImageView];
        // place a clickable button on top of everything

        
        if (self.isRemovable) {
            // place a remove button on top right corner for removing item from the board
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float w = 100;
            float h = 100;
            
            [deleteButton setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, w, h)];
            //[deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
            deleteButton.backgroundColor = [UIColor clearColor];
            [deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setHidden:YES];
            [self addSubview:deleteButton];
            
        } else{
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:self.bounds];
            //        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:titleText forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            //        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
            //        [self addGestureRecognizer:longPress];
            //        longPress = nil;
            [self addSubview:button];
        }
    }
    return self;
}

#pragma mark - UI actions

- (void) clickItem:(id)sender
{
    [delegate gridItemDidClicked:self];
}

- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer{
    
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            point = [gestureRecognizer locationInView:self];
//            [delegate gridItemDidEnterEditingMode:self];
//            //放大这个item
//            [self setAlpha:1.0];
//            NSLog(@"press long began");
//            break;
//        case UIGestureRecognizerStateEnded:
////            point = [gestureRecognizer locationInView:self];
////            [delegate gridItemDidEndMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
////            //变回原来大小
////            [self setAlpha:0.5f];
////            NSLog(@"press long ended");
////            break;
//        case UIGestureRecognizerStateFailed:
//            NSLog(@"press long failed");
//            break;
//        case UIGestureRecognizerStateChanged:
//            //移动
//            
////            [delegate gridItemDidMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
////            NSLog(@"press long changed");
////            break;
//        default:
//            NSLog(@"press long else");
//            break;
//    }
//    
    //CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    
}

- (void) removeButtonClicked:(id) sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"删除照片"
                                                   otherButtonTitles:nil];
    [actionsheet showInView:self];
    [actionsheet release];
   
}

#pragma mark - Custom Methods

- (void) enableEditing
{
    
    if (self.isEditing == YES)
        return;
    
    // put item in editing mode
    self.isEditing = YES;
    
    // make the remove button visible
    [deleteButton setHidden:NO];
    [button setEnabled:NO];    
}

- (void) disableEditing
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [deleteButton setHidden:YES];
    [button setEnabled:YES];
    self.isEditing = NO;
}

# pragma mark - Overriding UiView Methods

- (void) removeFromSuperview
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }]; 
}

# pragma mark - acitonsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
         [delegate gridItemDidDeleted:self atIndex:index];
    }
}
@end
