//
//  HVAutostarter.m
//  iOSHierarchyViewer
//
//  Created by Maciej Gad on 17.01.2014.
//
//

#import "HVAutostarter.h"
#import <UIKit/UIKit.h>
#import "iOSHierarchyViewer.h"

@implementation HVAutostarter
+(void) load{
    [HVAutostarter sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
-(id) init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(start)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    }
    return self;
}
-(void) start{
    [iOSHierarchyViewer start];
}
@end
