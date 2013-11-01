//
//  iOSHierarchyViewer.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <Foundation/NSURL.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "iOSHierarchyViewer.h"
#import "HVDefines.h"
#import "HVHierarchyHandler.h"
#import "HVHTTPServer.h"
#import "HVPreviewHandler.h"
#import "HVBase64StaticFile.h"
#import "HVPropertyEditorHandler.h"
#import "HVCoreDataHandler.h"

#import "webapp_index_ui.h"
#import "webapp_index_core.h"
#import "webapp_navbar.h"
#import "webapp_jquery.h"
#import "webapp_style.h"

@implementation iOSHierarchyViewer

static HVHTTPServer *server = nil;
static HVCoreDataHandler *coreDataHandler = nil;

+ (void)logServiceAdresses
{
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  NSLog(@"#### iOS Hierarchy Viewer ver: %@ ####", @IOS_HIERARCHY_VIEWER_VERSION);
  if (getifaddrs(&interfaces) == 0) {
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == AF_INET) {
        NSLog(@"(%@): %@",
              [NSString stringWithUTF8String:temp_addr->ifa_name],
              [NSString stringWithFormat:@"http://%@:%d", [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)], IOS_HIERARCHY_VIEWER_PORT]);
      }
      temp_addr = temp_addr->ifa_next;
    }
  }
  NSLog(@"#######################################");
  freeifaddrs(interfaces);
}

+ (BOOL)start
{
  if (server) {
    return YES;
  }
  server = [[HVHTTPServer server] retain];
  [server registerHandler:[HVHierarchyHandler handler] forUrl:@"/snapshot"];
  [server registerHandler:[HVBase64StaticFile handler:WEBAPP_INDEX_UI] forUrls:[NSArray arrayWithObjects:@"", @"/", @"/index", @"/index.html", nil]];
  [server registerHandler:[HVBase64StaticFile handler:WEBAPP_INDEX_CORE] forUrl:@"/core.html"];
  [server registerHandler:[HVBase64StaticFile handler:WEBAPP_JQUERY] forUrl:@"/jquery.js"];
  [server registerHandler:[HVBase64StaticFile handler:WEBAPP_NAVBAR] forUrl:@"/navbar.js"];
  [server registerHandler:[HVBase64StaticFile handler:WEBAPP_STYLE] forUrl:@"/style.css"];
  [server registerHandler:[HVPreviewHandler handler] forUrl:@"/preview"];
  [server registerHandler:[HVPropertyEditorHandler handler] forUrl:@"/update"];
  coreDataHandler = [[HVCoreDataHandler handler] retain];
  [server registerHandler:coreDataHandler forUrl:@"/core"];
  if ([server start:IOS_HIERARCHY_VIEWER_PORT]) {
    [iOSHierarchyViewer logServiceAdresses];
    return YES;
  }
  return NO;
}

+ (void)stop
{
  if (server) {
    [coreDataHandler release];
    coreDataHandler = nil;
    [server stop];
    [server release];
    server = nil;
  }
}

+ (void) addContext:(NSManagedObjectContext*)context name:(NSString*)name
{
  if ( coreDataHandler ) {
    [coreDataHandler pushContext:context withName:name];
  }
}

+ (void) removeContext:(NSString*)name
{
  if ( coreDataHandler ) {
    [coreDataHandler popContext:name];
  }
}

@end
