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
- (void) downloadImage:(NSString*)imageURL;
@end

@implementation AsyncImageView


- (void) loadImage:(NSString*)imageURL {
    [self loadImage:imageURL withPlaceholdImage:nil];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage {
    self.image = placeholdImage;
    
    /*
    UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
    if (image) 
        self.image = image;
    else
        [self downloadImage:imageURL];
     */

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image) 
                self.image = image;
            else
                [self downloadImage:imageURL];
        });
    });

}

- (void) downloadImage:(NSString *)imageURL {
	NSString *newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *downloadDestinationPath = [[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL];
    //    NSLog(@"image path:%@", downloadDestinationPath);
    //    [[RKClient sharedClient] ]
    [[RKClient sharedClient] setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [[RKClient sharedClient] get:newImageURL usingBlock:^(RKRequest *request){
        // success
        NSLog(@"requet url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK) {
                NSString *imageURL = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[response body] writeToFile:downloadDestinationPath atomically:YES];
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.image = image;
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

@end
