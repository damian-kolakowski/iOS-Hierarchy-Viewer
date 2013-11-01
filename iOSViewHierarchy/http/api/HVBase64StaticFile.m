//
//  HVBase64StaticFile.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import "HVBase64StaticFile.h"

@implementation HVBase64StaticFile

+ (HVBase64StaticFile *)handler:(NSString *)base64String
{
  return [[[HVBase64StaticFile alloc] initWith:base64String] autorelease];
}

- (id) initWith:(NSString*)base64String;
{
  self = [super init];
  if (self) {
    cachedResponse = [[self base64DataFromString:base64String] retain];
  }
  return self;
}

- (void)dealloc
{
  [cachedResponse release];
  cachedResponse = nil;
  [super dealloc];
}

- (NSData *)base64DataFromString:(NSString *)string
{
  unsigned long ixtext, lentext;
  unsigned char ch, inbuf[4], outbuf[3];
  short i, ixinbuf;
  Boolean flignore, flendtext = false;
  const unsigned char *tempcstring;
  NSMutableData *theData;

  if (string == nil) {
    return [NSData data];
  }

  ixtext = 0;

  tempcstring = (const unsigned char *)[string UTF8String];

  lentext = [string length];

  theData = [NSMutableData dataWithCapacity:lentext];

  ixinbuf = 0;

  while (true) {
    if (ixtext >= lentext) {
      break;
    }

    ch = tempcstring [ixtext++];

    flignore = false;

    if ((ch >= 'A') && (ch <= 'Z')) {
      ch = ch - 'A';
    }
    else if ((ch >= 'a') && (ch <= 'z')) {
      ch = ch - 'a' + 26;
    }
    else if ((ch >= '0') && (ch <= '9')) {
      ch = ch - '0' + 52;
    }
    else if (ch == '+') {
      ch = 62;
    }
    else if (ch == '=') {
      flendtext = true;
    }
    else if (ch == '/') {
      ch = 63;
    }
    else {
      flignore = true;
    }

    if (!flignore) {
      short ctcharsinbuf = 3;
      Boolean flbreak = false;

      if (flendtext) {
        if (ixinbuf == 0) {
          break;
        }

        if ((ixinbuf == 1) || (ixinbuf == 2)) {
          ctcharsinbuf = 1;
        }
        else {
          ctcharsinbuf = 2;
        }

        ixinbuf = 3;

        flbreak = true;
      }

      inbuf [ixinbuf++] = ch;

      if (ixinbuf == 4) {
        ixinbuf = 0;

        outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
        outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
        outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);

        for (i = 0; i < ctcharsinbuf; i++) {
          [theData appendBytes:&outbuf[i] length:1];
        }
      }

      if (flbreak) {
        break;
      }
    }
  }

  return theData;
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  if ([super handleRequest:url withHeaders:headers query:query address:address onSocket:socket]) {
    return [self writeData:cachedResponse toSocket:socket];
  }
  return NO;
}


@end
