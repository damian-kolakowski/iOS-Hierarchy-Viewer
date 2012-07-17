//
//  HVPreviewHandler.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "HVPreviewHandler.h"
#import "HVHierarchyScanner.h"

@implementation HVPreviewHandler

+ (HVPreviewHandler *)handler
{
  return [[[HVPreviewHandler alloc] init] autorelease];
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  if ([super handleRequest:url withHeaders:headers query:query address:address onSocket:socket]) {
    if ([self writeText:@"\r\n" toSocket:socket]) {
      if ([query objectForKey:@"id"]) {
        long id = [(NSString *)[query objectForKey:@"id"] longLongValue];
        UIView *view = [HVHierarchyScanner findViewById:id];
        if (view) {
          UIGraphicsBeginImageContext(view.bounds.size);
          
          [view.layer renderInContext:UIGraphicsGetCurrentContext()];
          UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

          NSData *pngData = UIImagePNGRepresentation(image);
          UIGraphicsEndImageContext();

          return [self writeData:(char *)[pngData bytes] length:[pngData length] toSocket:socket];
        }
      } else {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenHeight));
        for (UIWindow *w in [[UIApplication sharedApplication] windows]) {
          [w.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        NSData *scaledData = UIImagePNGRepresentation(image);
        UIGraphicsEndImageContext();
        return [self writeData:(char *)[scaledData bytes] length:[scaledData length] toSocket:socket];
      }
    }
  }
  return NO;
}

@end
