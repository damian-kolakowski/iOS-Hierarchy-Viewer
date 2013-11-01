//
//  HVBaseRequestHandler.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <sys/socket.h>
#import "HVBaseRequestHandler.h"

@implementation HVBaseRequestHandler

- (BOOL)writeRawData:(char *)data length:(int)length toSocket:(int)socket;
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

- (BOOL)writeData:(NSData*)data toSocket:(int)socket
{
  return [self writeRawData:(char*)[data bytes] length:[data length] toSocket:socket];
}

- (BOOL)writeText:(NSString *)text toSocket:(int)socket
{
  if (text) {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    return [self writeRawData:(char *)[data bytes] length:[data length] toSocket:socket];
  }
  return NO;
}

- (BOOL)writeJSONErrorResponse:(NSString*)error toSocket:(int)socket
{
  return [self writeJSONResponse:[NSDictionary dictionaryWithObject:error forKey:@"error"] toSocket:socket];
}

- (BOOL)writeJSONResponse:(id)object toSocket:(int)socket
{
  NSError* serializationError = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions
                                                     error:&serializationError];
    if ( data ) {
      return [self writeData:data toSocket:socket];
    } else {
      if ( serializationError ) {
        return [self writeJSONErrorResponse: serializationError.description toSocket:socket];
      } else {
        return [self writeJSONErrorResponse: @"Unknown error occured during JSON serialization." toSocket:socket];
      }
    }
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  return [self writeText:@"HTTP/1.0 200 OK\r\n\r\n" toSocket:socket];
}

@end
