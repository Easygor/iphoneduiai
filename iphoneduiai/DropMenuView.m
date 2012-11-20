//
//  DropMenuView.m
//  cosmetics
//
//  Created by Cloud Dai on 12-9-20.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import "DropMenuView.h"

#define INIH 10

@interface DropMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableVew;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) UIView *containerView;
@property (retain, nonatomic) IBOutlet UIImageView *bgImgView;

@end

@implementation DropMenuView
@synthesize options=_options;

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    [_tableVew release];
    [_options release];
    [_bgImgView release];
    [super dealloc];
}

- (NSArray *)options
{
    if (_options == nil) {
        _options = [[self.dataSource dropMenuViewData:self] retain];
    }
    
    return _options;
}

- (BOOL)visible
{
    if (self.superview == nil) {
        return  NO;
    }
    
    return  YES;
}

- (void)awakeFromNib
{

    self.bgImgView.image = [[UIImage imageNamed:@"tips_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:35];
//    self.bgImgView.image = [[UIImage imageNamed:@"tips_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 50, 30, 5)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifierId = @"dropmenu";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIndentifierId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifierId] autorelease];
        UIImageView *selectedView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)] autorelease];
        selectedView.image = [[UIImage imageNamed:@"tips_btn"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];

        cell.selectedBackgroundView = selectedView;
        
        cell.textLabel.textColor = RGBCOLOR(102, 102, 102);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        // line
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIImageView *bgLine = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_line"]] autorelease];
        if (scale > 1.0) {
            bgLine.frame = CGRectMake(0, 35, cell.bounds.size.width, 1);

        } else{
            bgLine.frame = CGRectMake(0, 34, cell.bounds.size.width, 2);
        }
        
        [cell.contentView addSubview:bgLine];
    }
    
    id data = [self.options objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = [(NSDictionary *)data objectForKey:@"name"];
    } else{
        cell.textLabel.text = (NSString *)data;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *tag = nil, *name=nil;
    id data = [self.options objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[NSDictionary class]]) {
        tag = [data objectForKey:@"tag"];
        name = [data objectForKey:@"name"];
    } else{
        tag = data;
        name = data;
    }

    if ([self.delegate respondsToSelector:@selector(didSelectedMenuCell:withTag:name:)]) {

        [self.delegate didSelectedMenuCell:self withTag:tag name:name];
    }
    
    [self removeMeWithAnimated:YES];
}

- (void)tapGestureAction:(UITapGestureRecognizer*)gesture
{

    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:gesture.view];
        if (CGRectContainsPoint(self.frame, point)) {
            // do
        } else{
            [self removeMeWithAnimated:YES];
        }
    
    }
}

- (void)showMeAtView:(UIView*)view atPoint:(CGPoint)pos animated:(BOOL)animated
{
    
    if (self.containerView == nil) {
        self.containerView = [[[UIView alloc] initWithFrame:view.window.frame] autorelease];
        self.containerView.backgroundColor = [UIColor clearColor];
        self.containerView.opaque = YES;
        self.containerView.clipsToBounds = NO;
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)] autorelease];
        tap.delegate = self;
        [self.containerView addGestureRecognizer:tap];
    }
    
    [view.window addSubview:self.containerView];
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = pos.x;
    selfFrame.origin.y = pos.y;
    
    if (animated) {

        self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, INIH);;
        [self.containerView addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, selfFrame.size.height);
        }];
        
    } else{
        self.frame = selfFrame;
        [self.containerView addSubview:self];
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
                             [self.containerView removeFromSuperview];
                             self.frame = selfFrame;
                         }];
    } else{
        [self removeFromSuperview];
        [self.containerView removeFromSuperview];
    }
}

- (void)reloadData
{
    [self.tableVew reloadData];
}

#pragma mark - getsture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.frame, point)) {
        return NO;
    }
    
    return YES;
}

@end
