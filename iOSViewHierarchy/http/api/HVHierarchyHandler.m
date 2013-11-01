//
//  HVHierarchyHandler.h
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import "HVDefines.h"
#import "HVHierarchyHandler.h"
#import "HVHierarchyScanner.h"

@implementation HVHierarchyHandler

+ (HVHierarchyHandler *)handler
{
  return [[[HVHierarchyHandler alloc] init] autorelease];
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  if ([super handleRequest:url withHeaders:headers query:query address:address onSocket:socket]) {
    NSArray *hierarchyDict = [HVHierarchyScanner hierarchySnapshot];
    
    NSMutableDictionary *responseDic = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [responseDic setValue:hierarchyDict forKey:@"windows"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [responseDic setValue:[NSNumber numberWithFloat:screenRect.size.width] forKey:@"screen_w"];
    [responseDic setValue:[NSNumber numberWithFloat:screenRect.size.height] forKey:@"screen_h"];
    [responseDic setValue:@IOS_HIERARCHY_VIEWER_VERSION forKey:@"version"];
    //[responseDic setValue:[NSArray arrayWithObjects:@"CGRect", @"CGPoint", @"NSString", @"BOOL", nil] forKey:@"editable"];
    return [self writeJSONResponse:responseDic toSocket:socket];
  }
  return NO;
}

@end
