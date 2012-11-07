//
//  AppDelegate.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaisedCenterButton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) RaisedCenterButton *raisedBtn;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
