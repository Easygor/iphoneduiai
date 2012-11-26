//
//  Notification.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (nonatomic) NSInteger messageCount, feedCount, noticeCount;

+ (Notification*)sharedInstance;
- (void)updateFromRemote:(void(^)())block;
- (NSMutableArray*)mergeAndOrderNotices;
- (void)removeNoticeObject:(NSDictionary*)d;
- (void)saveDataToPlist;
- (void)updateMessage:(NSDictionary*)d;
- (NSMutableDictionary*)getMessageWithUid:(NSString*)uid;
- (void)clearAllBages;

@end
