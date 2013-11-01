//
//  HVHierarchyScanner.h
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

CGFloat handleNotFinite(CGFloat value);

@interface HVHierarchyScanner : NSObject

+ (NSDictionary *)recursivePropertiesScan:(UIView *)view;

+ (NSArray *)hierarchySnapshot;

+ (UIView *)findViewById:(long)id;

@end
