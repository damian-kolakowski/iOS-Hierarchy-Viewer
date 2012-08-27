//
//  iOSHierarchyViewer.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface iOSHierarchyViewer : NSObject

+ (BOOL)start;

+ (void)stop;

+ (void) addContext:(NSManagedObjectContext*)context name:(NSString*)name;

+ (void) removeContext:(NSString*)name;

@end
