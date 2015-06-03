//
//  HVCoreDataHandler.h
//
//  Copyright (c) 2015 Damian Kolakowski. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HVBaseRequestHandler.h"

@interface HVCoreDataHandler : HVBaseRequestHandler {
  NSMutableDictionary* contextDictionary;
}

+ (HVCoreDataHandler *)handler;

- (void) pushContext:(NSManagedObjectContext*)context withName:(NSString*)name;
- (void) popContext:(NSString*)name;


@end
