//
//  HVBaseRequestHandler.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <sys/socket.h>
#import "HVBaseRequestHandler.h"

@implementation HVBaseRequestHandler

- (BOOL)writeData:(char *)data length:(int)length toSocket:(int)socket;
{
  int sent = 0;
  while (sent < length) {
    int s = write(socket, data + sent, length - sent);
    if (s > 0) {
      sent += s;
    } else {
      return NO;
    }
  }
  return YES;
}

- (BOOL)writeText:(NSString *)text toSocket:(int)socket
{
  if (text) {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    return [self writeData:(char *)[data bytes] length:[data length] toSocket:socket];
  }
  return NO;
}

- (BOOL)writeOKStatus:(int)socket
{
  return [self writeText:@"HTTP/1.0 200 OK\r\n" toSocket:socket];
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  return [self writeOKStatus:socket];
}

@end
