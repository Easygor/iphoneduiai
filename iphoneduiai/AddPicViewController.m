//
//  AddPicViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-6.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AddPicViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"

#define columns 3
#define rows 3
#define itemsPerPage 9
#define space 10
#define gridHight 100
#define gridWith 100
#define unValidIndex  -1
#define threshold 30


@interface AddPicViewController ()
-(NSInteger)indexOfLocation:(CGPoint)location;
-(CGPoint)orginPointOfIndex:(NSInteger)index;
-(void) exchangeItem:(NSInteger)oldIndex withposition:(NSInteger) newIndex;
@end

@implementation AddPicViewController
@synthesize scrollview;


- (void)dealloc
{
    [_showPhotoView release];
    [scrollview release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"管理我的照片"];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"上传照片"target:self action:@selector(addbutton)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    page = 0;
    isEditing = NO;
    addbutton = [[BJGridItem alloc] initWithTitle:nil withImageName:@"add_pic.png" atIndex:0 editable:NO];
    
    [addbutton setFrame:CGRectMake(0, 10, 100, 100)];
    addbutton.delegate = self;
    [scrollview addSubview: addbutton];
    gridItems = [[NSMutableArray alloc] initWithCapacity:9];
    [gridItems addObject:addbutton];
    scrollview.delegate = self;
    [scrollview setPagingEnabled:YES];
    singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [scrollview addGestureRecognizer:singletap];
    /* *******start********** */
    [self doInitWork];
    /* *******end********** */
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    
    [self setScrollview:nil];
    addbutton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark-- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.view.frame;
    
    frame.origin.x = preFrame.origin.x + (preX - scrollView.contentOffset.x)/10 ;
    
    
    if (frame.origin.x <= 0 && frame.origin.x > scrollView.frame.size.width - frame.size.width ) {
        self.view.frame = frame;
    }
//    NSLog(@"offset:%f",(scrollView.contentOffset.x - preX));
//    NSLog(@"origin.x:%f",frame.origin.x);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    preX = scrollView.contentOffset.x;
    preFrame = self.view.frame;

}

- (void)addbutton
{
    // upload
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"从资源库",@"拍照",nil];

        [actionSheet showInView:self.view.window];
        [actionSheet release];
        
    } else {
        
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
//        picker.allowsEditing = YES;
        
        [self presentModalViewController:picker animated:YES];
    }

   
}

- (void)doInitWork
{
    for (NSDictionary *photo in self.showPhotoView.photos) {
        [self addPic];
        [preGridItem setImgWithName:photo[@"icon"]];
    }
}

-(void)addPic
{
    CGRect frame = CGRectMake(0, 10, 100, 100);
    int n = [gridItems count];
    int row = (n-1) / 3;
    int col = (n-1) % 3;
    int curpage = (n-1) / itemsPerPage;
    row = row % 3;
    if (n / 9 + 1 > 9) {

    }else{
        frame.origin.x = frame.origin.x + frame.size.width * col + 10 * col + scrollview.frame.size.width * curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 10 * row;
        
        preGridItem = [[BJGridItem alloc] initWithTitle:nil withImageName:nil atIndex:n-1 editable:YES];
        [preGridItem enableEditing];
        [preGridItem setFrame:frame];
        
        [preGridItem setAlpha:1.0];
        preGridItem.delegate = self;
        [gridItems insertObject:preGridItem atIndex:n-1];
        [scrollview addSubview:preGridItem];
        
        
        //move the add button
        row = n / 3;
        col = n % 3;
        curpage = n / 9;
        row = row % 3;
        frame = CGRectMake(0, 10, 100, 100);
        frame.origin.x = frame.origin.x + frame.size.width * col + 10 * col + scrollview.frame.size.width * curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 10 * row;

        [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width * (curpage + 1), scrollview.frame.size.height)];
        [scrollview scrollRectToVisible:CGRectMake(scrollview.frame.size.width * curpage, scrollview.frame.origin.y, scrollview.frame.size.width, scrollview.frame.size.height) animated:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [addbutton setFrame:frame];
        }];
        addbutton.index += 1;
    }

}
#pragma mark-- BJGridItemDelegate
- (void)gridItemDidClicked:(BJGridItem *)gridItem{

    if (gridItem.index == [gridItems count]-1) {
        [self addbutton];
    }
}
- (void)gridItemDidDeleted:(BJGridItem *)gridItem atIndex:(NSInteger)index{

    NSDictionary *photo = [self.showPhotoView.photos objectAtIndex:index];
    [Utils deleteImage:photo[@"pid"] block:^{
        BJGridItem * item = [gridItems objectAtIndex:index];
        
        [gridItems removeObject:item];
//        [self.photos removeObject:photo];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect lastFrame = item.frame;
            [addbutton setFrame:lastFrame];
            CGRect curFrame;
            for (int i=index; i < [gridItems count]; i++) {
                BJGridItem *temp = [gridItems objectAtIndex:i];
                curFrame = temp.frame;
                [temp setFrame:lastFrame];
                
                lastFrame = curFrame;
                [temp setIndex:i];
            }
        }];
        [item removeFromSuperview];
        item = nil;
        
        [self.showPhotoView removePhotoAt:index];
    }];

}
- (void)gridItemDidEnterEditingMode:(BJGridItem *)gridItem{

    for (BJGridItem *item in gridItems) {

        [item enableEditing];
    }
    isEditing = YES;
}
- (void)gridItemDidMoved:(BJGridItem *)gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    CGRect frame = gridItem.frame;
    CGPoint _point = [recognizer locationInView:self.scrollview];
    CGPoint pointInView = [recognizer locationInView:self.view];
    frame.origin.x = _point.x - point.x;
    frame.origin.y = _point.y - point.y;
    gridItem.frame = frame;


    
    NSInteger toIndex = [self indexOfLocation:_point];
    NSInteger fromIndex = gridItem.index;

    
    if (toIndex != unValidIndex && toIndex != fromIndex) {
        BJGridItem *moveItem = [gridItems objectAtIndex:toIndex];
        [scrollview sendSubviewToBack:moveItem];
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint origin = [self orginPointOfIndex:fromIndex];
            //NSLog(@"origin:%f,%f",origin.x,origin.y);
            moveItem.frame = CGRectMake(origin.x, origin.y, moveItem.frame.size.width, moveItem.frame.size.height);
        }];
        [self exchangeItem:fromIndex withposition:toIndex];
        //移动
        
    }
    //翻页
    if (pointInView.x >= scrollview.frame.size.width - threshold) {
        [scrollview scrollRectToVisible:CGRectMake(scrollview.contentOffset.x + scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    }else if (pointInView.x < threshold) {
        [scrollview scrollRectToVisible:CGRectMake(scrollview.contentOffset.x - scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    }
    
    
    
}
- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer{
    CGPoint _point = [recognizer locationInView:self.scrollview];
    NSInteger toIndex = [self indexOfLocation:_point];
    if (toIndex == unValidIndex) {
        toIndex = gridItem.index;
    }
    CGPoint origin = [self orginPointOfIndex:toIndex];
    [UIView animateWithDuration:0.2 animations:^{
        gridItem.frame = CGRectMake(origin.x, origin.y, gridItem.frame.size.width, gridItem.frame.size.height);
    }];

}

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
    if (isEditing) {
        for (BJGridItem *item in gridItems) {
            [item disableEditing];
        }
        [addbutton disableEditing];
    }
    isEditing = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != scrollview){
        return NO;
    }else
        return YES;
}

#pragma mark-- private
- (NSInteger)indexOfLocation:(CGPoint)location{
    NSInteger index;
    NSInteger _page = location.x / 320;
    NSInteger row =  location.y / (gridHight + 20);
    NSInteger col = (location.x - _page * 320) / (gridWith + 20);
    if (row >= rows || col >= columns) {
        return  unValidIndex;
    }
    index = itemsPerPage * _page + row * 2 + col;
    if (index >= [gridItems count]) {
        return  unValidIndex;
    }
    
    return index;
}

- (CGPoint)orginPointOfIndex:(NSInteger)index{
    CGPoint point = CGPointZero;
    if (index > [gridItems count] || index < 0) {
        return point;
    }else{
        NSInteger _page = index / itemsPerPage;
        NSInteger row = (index - _page * itemsPerPage) / columns;
        NSInteger col = (index - _page * itemsPerPage) % columns;
        
        point.x = _page * 320 + col * gridWith + (col +1) * space;
        point.y = row * gridHight + (row + 1) * space;
        return  point;
    }
}

- (void)exchangeItem:(NSInteger)oldIndex withposition:(NSInteger)newIndex{
    ((BJGridItem *)[gridItems objectAtIndex:oldIndex]).index = newIndex;
    ((BJGridItem *)[gridItems objectAtIndex:newIndex]).index = oldIndex;
    [gridItems exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}

#pragma mark Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSData *data = UIImageJPEGRepresentation(([Utils thumbnailWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] size:CGSizeMake(640, 960)]), 0.9);
    [Utils uploadImage:data type:@"userphoto" block:^(NSMutableDictionary *res){
        if (res) {
//            [self.photos addObject:res]; // add pics

            [self addPic];
            curImg = [info objectForKey:UIImagePickerControllerOriginalImage];
            [preGridItem setImg:curImg];
            [self.showPhotoView insertPhoto:res atIndex:self.showPhotoView.photos.count];
        }
    }];

    [picker dismissModalViewControllerAnimated:YES];

}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark  actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init]autorelease];
    
    if (buttonIndex == 0)
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    else  if(buttonIndex==1)
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        return;
    imagePickerController.delegate=self;
//    imagePickerController.editing = YES;

    [self presentModalViewController: imagePickerController
                            animated: YES];
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}
@end
