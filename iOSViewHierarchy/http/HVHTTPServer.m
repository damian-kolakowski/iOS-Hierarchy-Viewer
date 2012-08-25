//
//  HVTinyHTTPServer.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <assert.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <Foundation/NSURL.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "HVHTTPServer.h"

@implementation HVHTTPServer

+ (HVHTTPServer*) server
{
  return [[[HVHTTPServer alloc] init] autorelease];
}

- (id)init
{
  self = [super init];
  if (self) {
    handlers = [[NSMutableDictionary alloc] initWithCapacity:10];
  }
  return self;
}

- (void)dealloc
{
  [self stop];
  [handlers release];
  handlers = nil;
  [super dealloc];
}

- (void)cleanSocket:(int)socket
{
  shutdown(socket, 2);
  close(socket);
}

- (NSData *)line:(int)socket
{
  NSMutableData *lineData = [[[NSMutableData alloc] initWithCapacity:100] autorelease];
  char buff[1];
  int r = 0;
  do {
    r = recv(socket, buff, 1, 0);
    if (r > 0 && buff[0] > '\r') {
      [lineData appendBytes:buff length:1];
    }
  } while (r > 0 && buff[0] != '\n');
  if (r == -1) {
    return nil;
  }
  return lineData;
}

- (NSDictionary *)queryParameters:(NSURL *)url
{
  NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
  NSString *urlQuery = [url query];
  if (urlQuery) {
    NSArray *tokens = [urlQuery componentsSeparatedByString:@"&"];
    if (tokens) {
      for (int i = 0; i < [tokens count]; ++i) {
        NSString *parameter = [tokens objectAtIndex:i];
        if (parameter) {
          NSArray *paramTokens = [parameter componentsSeparatedByString:@"="];
          if ([paramTokens count] >= 2) {
            NSString *paramName = [paramTokens objectAtIndex:0];
            NSString *paramValue = [paramTokens objectAtIndex:1];
            if (paramValue && paramName) {
              NSString *escapedName = [paramName stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
              NSString *escapedValue = [paramValue stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
              if (escapedName && escapedValue) {
                [parameters setObject:escapedValue forKey:escapedName];
              }
            }
          }
        }
      }
    }
  }
  return parameters;
}

- (NSDictionary *)headers:(int)socket
{
  NSMutableDictionary *headersDictionary = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
  NSData *tmpLine = nil;

  do {
    tmpLine = [self line:socket];
    if (tmpLine) {
      int lineLength = [tmpLine length];
      if (lineLength > 0) {
        NSString *tmpLineString = [[[NSString alloc] initWithData:tmpLine encoding:NSASCIIStringEncoding] autorelease];
        NSArray *headerTokens = [tmpLineString componentsSeparatedByString:@":"];
        if (headerTokens && [headerTokens count] >= 2) {
          NSString *headerName = [headerTokens objectAtIndex:0];
          NSString *headerValue = [headerTokens objectAtIndex:1];
          if (headerName && headerValue) {
            [headersDictionary setObject:headerValue forKey:headerName];
          }
        }
      }
      if (lineLength == 0) {
        break;
      }
    }
  } while (tmpLine);

  return headersDictionary;
}

- (void)handleClientConnection:(id)data
{
  NSArray *args = (NSArray *)data;

  NSString *address = [args objectAtIndex:0];
  int socket = [(NSNumber *)[args objectAtIndex:1] intValue];

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSData *httpInitLine = [self line:socket];
  if (httpInitLine) {
    NSString *httpInitLineString = [[[NSString alloc] initWithData:httpInitLine encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"REQUEST HTTP INIT LINE: %@", httpInitLineString);
    NSArray *initLineTokens = [httpInitLineString componentsSeparatedByString:@" "];

    NSString *requestMethod = nil;
    NSURL *requestUrl = nil;

    if ([initLineTokens count] >= 3) {
      requestMethod = [initLineTokens objectAtIndex:0];
      NSString *requestUrlString = [initLineTokens objectAtIndex:1];
      if (requestUrlString) {
        requestUrl = [NSURL URLWithString:requestUrlString];
      }
    }

    NSDictionary *requestQueryParams = [self queryParameters:requestUrl];
    NSDictionary *requestHeaders = [self headers:socket];

    if (requestUrl) {
      NSString *relativePath = [requestUrl relativePath];
      if (relativePath) {
        NSObject <HVRequestHandler> *handler = nil;
        @synchronized (handlers) {
          handler = [handlers objectForKey:relativePath];
        }
        if (handler) {
          [handler handleRequest:relativePath withHeaders:requestHeaders query:requestQueryParams address:address onSocket:socket];
        }
      }
    }
  }
  [self cleanSocket:socket];
  [pool release];
}

- (NSString *)sockaddrToNSString:(struct sockaddr *)addr
{
  char str[20];
  if (addr->sa_family == AF_INET) {
    struct sockaddr_in *v4 = (struct sockaddr_in *)addr;
    const char *result = inet_ntop(AF_INET, &(v4->sin_addr), str, 20);
    if (result == NULL) {
      return nil;
    }
  }
  if (addr->sa_family == AF_INET6) {
    struct sockaddr_in6 *v6 = (struct sockaddr_in6 *)addr;
    const char *result = inet_ntop(AF_INET6, &(v6->sin6_addr), str, 20);
    if (result == NULL) {
      return nil;
    }
  }
  return [NSString stringWithUTF8String:str];
}

- (void)acceptClientConnectionsLoop
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  while (!done) {
    struct sockaddr clientAddr;
    unsigned int addrLen = sizeof(clientAddr);
    const int clientSocket = accept(listenSocket, (struct sockaddr *)&clientAddr, &addrLen);
    if (clientSocket == -1) {
      done = YES;
    } else {
      int no_sig_pipe = 1;
      setsockopt(clientSocket, SOL_SOCKET, SO_NOSIGPIPE, &no_sig_pipe, sizeof no_sig_pipe);
      NSString *clientIpAddress = [self sockaddrToNSString:&clientAddr];
      NSArray *args = [NSArray arrayWithObjects:clientIpAddress, [NSNumber numberWithInt:clientSocket], nil];
      if (clientIpAddress) {
        [self performSelectorInBackground:@selector(handleClientConnection:) withObject:args];
      }
    }
  }
  [self cleanSocket:listenSocket];
  [pool release];
}

- (void)registerHandler:(NSObject <HVRequestHandler> *)handler forUrl:(NSString *)url
{
  if (url && handler) {
    [handlers setValue:handler forKey:url];
  }
}

- (void)registerHandler:(NSObject <HVRequestHandler> *)handler forUrls:(NSArray *)urls
{
  if ( handler && urls ) {
    for ( NSString* url in urls ) {
      [self registerHandler:handler forUrl:url];
    }
  }
}

- (BOOL)start:(int)port
{
  listenPort = port;
  done = NO;
  struct sockaddr_in addr;
  memset(&addr, 0, sizeof addr);
  addr.sin_family = AF_INET;
  addr.sin_addr.s_addr = INADDR_ANY;
  addr.sin_port = htons(listenPort);
  listenSocket = socket(AF_INET, SOCK_STREAM, 0);
  if (listenSocket == -1) {
    return NO;
  }
  int value = 1;
  if (setsockopt(listenSocket, SOL_SOCKET, SO_REUSEADDR, &value, sizeof(value)) == -1) {
    [self cleanSocket:listenSocket];
    return NO;
  }

  int no_sig_pipe = 1;
  setsockopt(listenSocket, SOL_SOCKET, SO_NOSIGPIPE, &no_sig_pipe, sizeof no_sig_pipe);

  if (bind(listenSocket, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
    [self cleanSocket:listenSocket];
    return NO;
  }
  if (listen(listenSocket, 150 /* max connections */) == -1) {
    [self cleanSocket:listenSocket];
    return NO;
  }

  [self performSelectorInBackground:@selector(acceptClientConnectionsLoop) withObject:nil];
  return YES;
}

- (void)stop
{
  done = YES;
  [self cleanSocket:listenSocket];
}

@end
