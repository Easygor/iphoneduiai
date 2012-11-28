//
//  AsyncImageView.m
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "FullyLoaded.h"
#import <RestKit/RKClient.h>

@interface AsyncImageView ()

@property (strong, nonatomic) RKRequest *request;
@property (strong, nonatomic) NSString *urlString;


@end

@implementation AsyncImageView

- (void)clearImageAndRequest
{
//    self.image = nil;
//    [self.request cancel];
//    self.request = nil;
    
}

- (void)dealloc
{
    [self.request cancel];
    [_request release];
    [_urlString release];
    [super dealloc];
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
//        [_indicatorView setColor:[UIColor whiteColor]];
        [_indicatorView stopAnimating];
        _indicatorView.frame = CGRectMake((self.frame.size.width-37)/2, (self.frame.size.height-37)/2, 37, 37);
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

- (void) loadImage:(NSString*)imageURL
{
    [self loadImage:imageURL withBlock:nil];
}

- (void) loadImage:(NSString*)imageURL withBlock:(void(^)(void))block
{
    [self loadImage:imageURL withPlaceholdImage:nil withBlock:block];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage
{
    [self loadImage:imageURL withPlaceholdImage:placeholdImage withBlock:nil];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage withBlock:(void(^)(void))block
{

    if (self.image == nil || ![imageURL isEqualToString:self.urlString]) {

        self.urlString = imageURL;
        self.image = placeholdImage;


        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        if (image){
            self.image = image;
            if (block) {
                block();
            }
        } else{
            [self downloadImage:imageURL withBlock:block];
        }
        

        /*
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (image) {
                    self.image = image;
                    if (block) {
                        block();
                    }
                } else{
                    [self downloadImage:imageURL withBlock:block];
                }
                
            });
        });*/
    }


}

- (void) downloadImage:(NSString *)imageURL withBlock:(void(^)(void))block
{
	NSString *newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *downloadDestinationPath = [[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL];
    //    NSLog(@"image path:%@", downloadDestinationPath);
    //    [[RKClient sharedClient] ]
    RKRequestQueue *queue = [RKRequestQueue requestQueueWithName:@"imagedownload"];
    queue.requestTimeout = 30;
    queue.concurrentRequestsLimit = 3;
    [queue start];
    
    [queue cancelRequest:self.request];
    [self.request cancel];
    self.request = nil;
//    NSLog(@"queue: %@: %d", queue, queue.count);

    RKRequest *request = [RKRequest requestWithURL:[RKURL URLWithBaseURLString:newImageURL]];
    self.request = request;
    [request setAdditionalHTTPHeaders:@{@"Accept": @"image/*"}];
    [request setOnDidFailLoadWithError:^(NSError *error){

        NSLog(@"Download Image Error: %@, url:%@", [error localizedDescription], newImageURL);
    }];
    
    [request setOnDidLoadResponse:^(RKResponse *response){
        if (response.isOK) {
            NSString *imageURL = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[response body] writeToFile:downloadDestinationPath atomically:YES];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
            dispatch_async(queue, ^{
                UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.image = image;
                    if (block) {
                        block();
                    }
                });
            });
        }
    }];
    
    [queue addRequest:request];
    
}

+ (void) getImage:(NSString *)imageURL withBlock:(void(^)(UIImage *image))block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image && block) {
                block(image);
            } else{
                NSString *newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *downloadDestinationPath = [[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL];
                //    NSLog(@"image path:%@", downloadDestinationPath);
                //    [[RKClient sharedClient] ]
                
                [[RKClient sharedClient] get:newImageURL usingBlock:^(RKRequest *request){
                    [request setAdditionalHTTPHeaders:@{@"Accept": @"image/*"}];
                    // success
                    if ([newImageURL hasPrefix:@"http://"]) {
                        [request setURL:[RKURL URLWithBaseURLString:newImageURL]];
                    }
//                    NSLog(@"requet url: %@", request.URL);
                    [request setOnDidLoadResponse:^(RKResponse *response){
                        
                        if (response.isOK) {
                            NSString *imageURL = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            [[response body] writeToFile:downloadDestinationPath atomically:YES];
                            
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                            dispatch_async(queue, ^{
                                UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    if (block) {
                                        block(image);
                                    }
                                });
                            });
                        }
                    }];
                    // fail
                    [request setOnDidFailLoadWithError:^(NSError *error){
                        NSLog(@"Download Image Error: %@", [error localizedDescription]);
                    }];
                }];
            }
            
        });
    });
	
}

@end
