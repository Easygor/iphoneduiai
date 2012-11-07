//
//  AppDelegate.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "LocationController.h"
#import "Notification.h"
#import <RestKit/JSONKit.h>
#import "RaisedCenterButton.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [_tabBarController release];
    [_raisedBtn release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // register the apns
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    
    
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    RaisedCenterButton *button = [RaisedCenterButton buttonWithBgImage:[UIImage imageNamed:@"icon-weiyu"] hlImage:[UIImage imageNamed:@"icon-weiyu-linked"] forTabBarController:self.tabBarController];
    self.raisedBtn = button;
    [self.tabBarController.tabBar addSubview:button];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        
//        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_indicator_bg.png"]];
        // config the tab bar items
//        [self.indexItem setFinishedSelectedImage:[UIImage imageNamed:@"home_w.png"]
//                     withFinishedUnselectedImage:[UIImage imageNamed:@"home_g.png"]];
//        [self.cateItem setFinishedSelectedImage:[UIImage imageNamed:@"list_w.png"]
//                    withFinishedUnselectedImage:[UIImage imageNamed:@"list_g.png"]];
//        [self.collectItem setFinishedSelectedImage:[UIImage imageNamed:@"love_w.png"]
//                       withFinishedUnselectedImage:[UIImage imageNamed:@"love_g.png"]];
//        [self.myTaoItem setFinishedSelectedImage:[UIImage imageNamed:@"mytaobao_pressed"]
//                     withFinishedUnselectedImage:[UIImage imageNamed:@"mytaobao"]];
//        [self.moreItem setFinishedSelectedImage:[UIImage imageNamed:@"more_w.png"]
//                    withFinishedUnselectedImage:[UIImage imageNamed:@"more_g.png"]];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-bg"]];
    } else {
        [self.tabBarController.tabBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar-bg"]] autorelease]  atIndex:0];
    }
    
    [self configRestKit];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[Notification sharedInstance] saveDataToPlist];
    [self updateLocationAndUserInfo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[[LocationController sharedInstance] locationManager] startUpdatingLocation];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[LocationController sharedInstance] locationManager] stopUpdatingLocation];
        [self updateLocationAndUserInfo];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[Notification sharedInstance] saveDataToPlist];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iphoneduiai" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iphoneduiai.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - custom methods
- (void)configRestKit
{
//    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://api.duiai.com"];
    [objectManager.client setValue:@"Application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Mapping config
    
//    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
}

#pragma mark - register apns
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *devTokenStr = [[[deviceToken description]
                              stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                             stringByReplacingOccurrencesOfString:@" "
                             withString:@""];
    
    NSLog(@"device token: %@", devTokenStr);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", error);
}

#pragma mark - networking request
-(void)updateLocationAndUserInfo
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        return;
    }
    
    if ([LocationController sharedInstance].allow) {
        CLLocationCoordinate2D curLocation = [[[LocationController sharedInstance] location] coordinate];
        [self updateRequestWithLocation:curLocation];
    } else{
        [self updateRequestWithLocation:CLLocationCoordinate2DMake(0.0, 0.0)];
    }
    
}

-(void)updateRequestWithLocation:(CLLocationCoordinate2D)curLocation
{

    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:curLocation.longitude], @"jin",
                          [NSNumber numberWithFloat:curLocation.latitude], @"wei",
                          @"true", @"submitupdate",
                          nil];
    
    RKParams *params = [RKParams paramsWithDictionary:data];
    
    // per
    [[RKClient sharedClient] post:[@"/uc/updatelocation.api" stringByAppendingQueryParameters:[Utils queryParams]]
                       usingBlock:^(RKRequest *request){
                           // set params
                           [request setParams:params];
                           
                           // set successful block
                           [request setOnDidLoadResponse:^(RKResponse *response){
                               if (response.isOK && response.isJSON) {
                                   NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                                   NSLog(@"res: %@", data);
                                   if ([[data objectForKey:@"error"] intValue] == 0) {
                  
                                       NSMutableDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
                                       user[@"username"] = data[@"data"][@"searchindex"][@"username"];
                                       user[@"info"] = data[@"data"][@"userinfo"];
                                       [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"accesskey"] forKey:@"accesskey"];
                                       [[NSUserDefaults standardUserDefaults] setObject:user  forKey:@"user"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];

                                   } else{

                                       NSLog(@"fail: %@", [data objectForKey:@"message"]);
                                   }
                                   
                               }
                           }];
                           
                           // set error block
                           [request setOnDidFailLoadWithError:^(NSError *error){
                               NSLog(@"Network Error: %@", [error localizedDescription]);
                           }];
                       }];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // unselected the button
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index != 2 && self.raisedBtn.selected) {
        self.raisedBtn.selected = NO;
    }
    
    // hide or not
//    if (viewController.hidesBottomBarWhenPushed) {
//        self.raisedBtn.hidden = YES;
//    } else{
//        self.raisedBtn.hidden = NO;
//    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed) {
        float_t delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.raisedBtn.hidden = YES;
        });
//        self.raisedBtn.hidden = YES;
    }

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController.hidesBottomBarWhenPushed) {
//        float_t delayInSeconds = 0.3;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.raisedBtn.hidden = NO;
//        });
    }
}
@end
