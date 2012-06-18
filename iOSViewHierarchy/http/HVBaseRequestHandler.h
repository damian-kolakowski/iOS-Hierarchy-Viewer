//
//  HVBaseRequestHandler.h
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVHTTPServer.h"

@interface HVBaseRequestHandler : NSObject <HVRequestHandler>

- (BOOL)writeData:(char *)data length:(int)length toSocket:(int)socket;

- (BOOL)writeOKStatus:(int)socket;

- (BOOL)writeText:(NSString *)text toSocket:(int)socket;

@end
