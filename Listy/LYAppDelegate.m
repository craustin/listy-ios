//
//  LYAppDelegate.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import "LYAppDelegate.h"
#import "LYMasterViewController.h"
#import "LYItemData.h"

@implementation LYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *dateString = @"12-Jul-14";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yy";
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    LYItemData *item1 = [[LYItemData alloc] initWithTitle:@"Tasty Steak" url:@"http://meaty.com" cookedDate:nil cookedImage:nil];
    LYItemData *item2 = [[LYItemData alloc] initWithTitle:@"Moroccan Chicken" url:@"http://spicy.ma" cookedDate:nil cookedImage:nil];
    LYItemData *item3 = [[LYItemData alloc] initWithTitle:@"Chinese Dish" url:@"http://foods.cn" cookedDate:nil cookedImage:nil];
    LYItemData *item4 = [[LYItemData alloc] initWithTitle:@"Pizza" url:@"http://xiaoyi.co.uk" cookedDate:date cookedImage:nil];
    NSMutableArray *items = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
    
    UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
    LYMasterViewController *masterController = [navController.viewControllers objectAtIndex:0];
    masterController.items = items;
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
