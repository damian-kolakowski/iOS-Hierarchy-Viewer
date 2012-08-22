//
//  HVCoreDataHandler.h
//  iOSHierarchyViewer
//
//  Created by Damian Kolakowski on 8/21/12.
//
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
