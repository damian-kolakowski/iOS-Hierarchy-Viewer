//
//  HVStaticFileHandler.h
//
//  Copyright (c) 2015 Damian Kolakowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVBaseRequestHandler.h"

@interface HVStaticFileHandler : HVBaseRequestHandler {

  NSString *file;
}

+ (HVStaticFileHandler *)handler:(NSString *)filePath;

- (id)initWithFileName:(NSString *)filePath;

@end
