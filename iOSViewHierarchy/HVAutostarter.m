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
#import "NSObject+PropertyUtil.h"

@implementation HVAutostarter
+(void) load{
    NSLog(@"load");
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(start)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    }
    return self;
}

-(void) start{
    NSLog(@"start");
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *classProperities = [NSObject classPropsFor:[appDelegate class]];
    NSString *contextKey = nil;
    contextKey = [[classProperities objectForKey:@"NSManagedObjectContext"] retain];
    NSManagedObjectContext *contex = nil;
    if (contextKey != nil) {
        if ([appDelegate respondsToSelector:@selector(valueForKey:)]) {
            contex =[[appDelegate performSelector:@selector(valueForKey:) withObject:contextKey] retain];
        }
    }
    [iOSHierarchyViewer start];
    if (contex != nil) {
        [iOSHierarchyViewer addContext:contex name:contextKey];
    }

    [contextKey release];
    [contex release];
}
/*
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}*/
@end
