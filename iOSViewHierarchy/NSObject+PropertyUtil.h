//
//  NSObject+PropertyUtil.h
//  testiOSHierarchyViewer
//
//  Created by Maciej Gad on 28.01.2014.
//  Copyright (c) 2014 Maciej Gad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyUtil)
+ (NSDictionary *)classPropsFor:(Class)klass;
@end
