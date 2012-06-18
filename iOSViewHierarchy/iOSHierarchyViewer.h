//
//  iOSHierarchyViewer.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_HIERARCHY_VIEWER_VERSION "1.4"
#define IOS_HIERARCHY_VIEWER_PORT 9449

@interface iOSHierarchyViewer : NSObject

+ (BOOL)start;

+ (void)stop;

@end
