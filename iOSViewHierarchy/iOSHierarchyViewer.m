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
#import "HVHierarchyHandler.h"
#import "HVHTTPServer.h"
#import "HVPreviewHandler.h"
#import "HVStaticFileHandler.h"
#import "HVIndexBASE64.h"
#import "HVPropertyEditorHandler.h"

@implementation iOSHierarchyViewer

HVHTTPServer* server = nil;

- (id)init
{
    self = [super init];
    if (self) {}
    return self;
}

+(void) logServiceAdresses
{
    struct ifaddrs *interfaces  = NULL;
    struct ifaddrs *temp_addr   = NULL;
    NSLog(@"#### iOS Hierarchy Viewer ver: %@ ####", @IOS_HIERARCHY_VIEWER_VERSION);
    if (getifaddrs(&interfaces) == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                NSLog(@"(%@): %@", [NSString stringWithUTF8String:temp_addr->ifa_name], [NSString stringWithFormat:@"http://%@:%d",
                [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)], IOS_HIERARCHY_VIEWER_PORT]);                
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    NSLog(@"#######################################");
    freeifaddrs(interfaces);
}

+(BOOL) start
{
    if ( server ) {
        return YES;
    }
    server = [[HVHTTPServer alloc] init];
    [server registerHandler:[HVHierarchyHandler handler] forUrl:@"/snapshot"];
    HVIndexBASE64* indexHandler = [HVIndexBASE64 handler];
    //HVStaticFileHandler* indexHandler = [HVStaticFileHandler handler:@"index2"];
    [server registerHandler:indexHandler forUrl:@""];
    [server registerHandler:indexHandler forUrl:@"/"];
    [server registerHandler:indexHandler forUrl:@"/index"];
    [server registerHandler:[HVPreviewHandler handler] forUrl:@"/preview"];
    [server registerHandler:[HVPropertyEditorHandler handler] forUrl:@"/update"];
    if ( [server start:IOS_HIERARCHY_VIEWER_PORT] ) {
        [iOSHierarchyViewer logServiceAdresses];
        return YES;
    }
    return NO;
}

+(void) stop
{
    if ( server ) {
        [server stop]; 
        [server release];
        server = nil;
    }
}

@end
