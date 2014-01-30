//
//  AppDelegate.h
//  PrettyExample
//
//  Created by Víctor on 28/02/12.
//  Copyright (c) 2012 Victor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  NSManagedObjectModel*_managedObjectModel;
  NSPersistentStoreCoordinator*_persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
