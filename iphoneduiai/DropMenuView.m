//
//  DropMenuView.m
//  cosmetics
//
//  Created by Cloud Dai on 12-9-20.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import "DropMenuView.h"

#define INIH 10

@interface DropMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableVew;
@property (strong, nonatomic) NSArray *options;

@end

@implementation DropMenuView
@synthesize options=_options;

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    [_tableVew release];
    [_options release];
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
        UIView *selectedView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)] autorelease];
        selectedView.backgroundColor = RGBCOLOR(255, 95, 143);
        cell.selectedBackgroundView = selectedView;
        
        cell.textLabel.textColor = RGBCOLOR(102, 102, 102);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
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

- (void)reloadData
{
    [self.tableVew reloadData];
}

@end
