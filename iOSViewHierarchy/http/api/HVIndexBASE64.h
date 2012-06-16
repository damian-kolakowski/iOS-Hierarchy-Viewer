//
//  HVIndexBASE64.h
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVBaseRequestHandler.h"

@interface HVIndexBASE64 : HVBaseRequestHandler {
    NSData* cachedResponse;
}

+(HVIndexBASE64*) handler;

@end
