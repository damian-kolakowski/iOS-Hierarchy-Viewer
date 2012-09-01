//
//  AppDelegate.m
//  PrettyExample
//
//  Created by Víctor on 28/02/12.
//  Copyright (c) 2012 Victor Pena Placer. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ExampleViewController.h"
#import "iOSHierarchyViewer.h"
#import "Product.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;

- (void)dealloc
{
    self.tabBarController = nil;
    [_window release];
    [_persistentStoreCoordinator release];
    [_managedObjectModel release];
    [_managedObjectContext release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [iOSHierarchyViewer start];
  
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
  
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSURL *storeUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.sqlite"]];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:nil];
  
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
  
    [iOSHierarchyViewer addContext:_managedObjectContext name:@"Root context"];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
  
    [self pushMockData];
  
    return YES;
}

- (void) pushMockData
{
  NSArray* mockNames = [NSArray arrayWithObjects:@"iPhone", @"iPad", @"iPod", nil];
  NSArray* mockPrices = [NSArray arrayWithObjects:@"100$", @"200$", @"300$", nil];
  NSArray* mockModels = [NSArray arrayWithObjects:@"white", @"black", @"orange", nil];
  
  for ( int i = 0 ; i < 20 ; ++ i ) {
    Product *newProduct = (Product*)[NSEntityDescription
                                  insertNewObjectForEntityForName:NSStringFromClass([Product class])
                                  inManagedObjectContext:_managedObjectContext];
    newProduct.name = [mockNames objectAtIndex:rand() % mockNames.count];
    newProduct.price = [mockPrices objectAtIndex:rand() % mockPrices.count];
    newProduct.model = [mockModels objectAtIndex:rand() % mockModels.count];
  }
  
  [_managedObjectContext save:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
