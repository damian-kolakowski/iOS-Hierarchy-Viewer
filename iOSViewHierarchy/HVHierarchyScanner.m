//
//  HVHierarchyScanner.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <objc/runtime.h>
#import <math.h>
#import "HVHierarchyScanner.h"
#import "JSONKit.h"


@implementation HVHierarchyScanner

CGFloat handleNaN(CGFloat value)
{
    if ( !isfinite(value) ) {
        return 1;
    }
    return value;
}

+(UIView*) recursiveSearchForView:(long)_id parent:(UIView*)parent
{
    if ( (void*)parent == _id ) return parent;
    for (UIView* v in [parent subviews]) {
        UIView* result = [HVHierarchyScanner recursiveSearchForView:_id parent:v];
        if ( result ) return result;
        
    }
    return  nil;
}

+(UIView*) findViewById:(long)_id
{
    UIApplication* app = [UIApplication sharedApplication];
    if ( app  ) {
        for ( UIView* v in [app windows] ) {
            UIView* result = [HVHierarchyScanner recursiveSearchForView:_id parent:v];
            if ( result ) return result;
        }
    }
    return nil;    
}

+(NSString*) UIColorToNSString:(UIColor*)color
{
    if ( color ) {
        CGColorSpaceRef colorSpac = CGColorGetColorSpace([color CGColor]);
        CGColorSpaceModel model = CGColorSpaceGetModel(colorSpac);
        
        NSString* prefix = @"A???";
        switch ( model ) 
        {
            case kCGColorSpaceModelCMYK: prefix = @"CMYKA"; break;
            case kCGColorSpaceModelDeviceN: prefix = @"DeviceNA"; break;
            case kCGColorSpaceModelIndexed: prefix = @"IndexedA"; break;
            case kCGColorSpaceModelLab: prefix = @"LabA"; break;
            case kCGColorSpaceModelMonochrome: prefix = @"MONOA"; break;
            case kCGColorSpaceModelPattern: prefix = @"APattern"; break;
            case kCGColorSpaceModelRGB: prefix = @"RGBA"; break;
            case kCGColorSpaceModelUnknown: prefix = @"A???"; break;
        }
        size_t n = CGColorGetNumberOfComponents([color CGColor]);
        const CGFloat* componentsArray = CGColorGetComponents([color CGColor]);
        
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:n];
        //[array addObject:[NSNumber numberWithInt:(int)(CGColorGetAlpha([color CGColor])*255.0f)]];
        for ( size_t i = 0 ; i < n ; ++i ) {
            [array addObject:[NSNumber numberWithInt:(int)(componentsArray[i]*255.0f)]];
        }
        NSString* components = [array componentsJoinedByString:@","];
        [array release];
        
        return [NSString stringWithFormat:@"%@(%@)", prefix, components];
    }
    return @"nil";
}

+ (id) readValueInUIThread:(NSObject*)obj property:(NSString*)propertyName
{
    id __block propertyValue = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try {
            propertyValue = [[obj valueForKey:propertyName] retain];
        } 
        @catch (NSException* ex) { 
            // we will return nil
        }
    });
    return [propertyValue autorelease];
}

+(NSMutableArray*) classProperties:(Class)class object:(NSObject*)obj
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    NSMutableArray* propertiesArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        NSMutableDictionary* propDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)];
        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property)];
        [propDic setValue:propertyName forKey:@"name"];
        
        NSArray * attributes = [propertyType componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * type = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [type UTF8String];
        
        BOOL readValue = NO;
        BOOL checkOnlyIfNil = NO;
    
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            [propDic setValue:@"float" forKey:@"type"];
            readValue = YES;
        } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
            [propDic setValue:@"double" forKey:@"type"];
            readValue = YES;
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            [propDic setValue:@"int" forKey:@"type"];
            readValue = YES;
        } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
            [propDic setValue:@"long" forKey:@"type"];
            readValue = YES;
        } else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            [propDic setValue:@"BOOL" forKey:@"type"];
            readValue = NO;
            NSNumber* propertyValue = [HVHierarchyScanner readValueInUIThread:obj property:propertyName];
            [propDic setValue: ( [propertyValue boolValue] ? @"YES" : @"NO" ) forKey:@"value"];
        } else if (strcmp(rawPropertyType, @encode(char)) == 0) {
            [propDic setValue:@"char" forKey:@"type"];
        } else if ( type && [type hasPrefix:@"@"] && [type length] > 3) {
            readValue = YES;
            checkOnlyIfNil = YES;
            NSString* typeClassName = [type substringWithRange:NSMakeRange(2, [type length]-3)];
            [propDic setValue:typeClassName forKey:@"type"];
            if ( [typeClassName isEqualToString:[[UIColor class] description]] ) {
                readValue = NO;
                id propertyValue = [HVHierarchyScanner readValueInUIThread:obj property:propertyName];
                [propDic setValue: ( propertyValue ? [HVHierarchyScanner UIColorToNSString:propertyValue] : @"nil" ) forKey:@"value"];
            }
            if ( [typeClassName isEqualToString:[[NSString class] description]] ) {
                checkOnlyIfNil = NO;
            }
            if ( [typeClassName isEqualToString:[[UIFont class] description]] ) {
                checkOnlyIfNil = NO;
            }
        } else {
            [propDic setValue:propertyType forKey:@"type"];
        }
        if ( readValue ) {
            id propertyValue = [HVHierarchyScanner readValueInUIThread:obj property:propertyName];
            if ( !checkOnlyIfNil ) {
                [propDic setValue: ( propertyValue != nil ? [NSString stringWithFormat:@"%@", propertyValue] : @"nil" ) forKey:@"value"];
            } else {
                [propDic setValue: ( propertyValue != nil ? @"OBJECT": @"nil" ) forKey:@"value"];
            }
        }
        [propertiesArray addObject:propDic];        
        [propertyName release];
        [propertyType release];
        [propDic release];
    }
    free(properties);
    return propertiesArray;
}

+(NSArray*) UIGeometryProps:(UIView*)view
{
    NSMutableArray* uiGeometryProperties = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    NSDictionary* frameDic = [NSDictionary dictionaryWithObjectsAndKeys: @"frame", @"name", @"CGRect", @"type", NSStringFromCGRect(view.frame), @"value", nil];
    [uiGeometryProperties addObject:frameDic];
    
    NSDictionary* boundsDic = [NSDictionary dictionaryWithObjectsAndKeys: @"bounds", @"name", @"CGRect", @"type", NSStringFromCGRect(view.bounds), @"value", nil];
    [uiGeometryProperties addObject:boundsDic];
    
    NSDictionary* centerDic = [NSDictionary dictionaryWithObjectsAndKeys: @"center", @"name", @"CGPoint", @"type", NSStringFromCGPoint(view.center), @"value", nil];
    [uiGeometryProperties addObject:centerDic];
    
    return uiGeometryProperties;
}

+(NSArray*) UIViewRenderingProps:(UIView*)view
{
    NSMutableArray* renderingProperties = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    NSDictionary* clipToBoundsDic = [NSDictionary dictionaryWithObjectsAndKeys: @"clipToBounds", @"name", @"BOOL", @"type", view.clipsToBounds ? @"YES" : @"NO", @"value", nil];
    [renderingProperties addObject:clipToBoundsDic];
    
    
    NSDictionary* backColorProp = [NSDictionary dictionaryWithObjectsAndKeys: @"backgroundColor", @"name", @"UIColor", @"type", [HVHierarchyScanner UIColorToNSString:view.backgroundColor], @"value", nil];
    [renderingProperties addObject:backColorProp];
    
    NSDictionary* alphaDic = [NSDictionary dictionaryWithObjectsAndKeys:  @"alpha", @"name", @"CGFloat", @"type", [NSString stringWithFormat:@"%f", view.alpha], @"value", nil];
    
    [renderingProperties addObject:alphaDic];
    
    NSDictionary* opaqueDic = [NSDictionary dictionaryWithObjectsAndKeys: @"opaque", @"name", @"BOOL", @"type", view.opaque ? @"YES" : @"NO", @"value", nil];
    
    [renderingProperties addObject:opaqueDic];
    
    NSDictionary* hiddenDic = [NSDictionary dictionaryWithObjectsAndKeys: @"hidden", @"name", @"BOOL", @"type",  view.hidden ? @"YES" : @"NO", @"value", nil];
    
    [renderingProperties addObject:hiddenDic];
    
    NSDictionary* contentModeDic = [NSDictionary dictionaryWithObjectsAndKeys: @"contentMode", @"name", @"UIViewContentMode", @"type", [NSString stringWithFormat:@"%d", view.contentMode], @"value", nil];
    
    [renderingProperties addObject:contentModeDic];
    
    NSDictionary* clearContextDic = [NSDictionary dictionaryWithObjectsAndKeys: @"clearsContextBeforeDrawing", @"name", @"BOOL", @"type", view.clearsContextBeforeDrawing ? @"YES" : @"NO", @"value", nil];
    
    [renderingProperties addObject:clearContextDic];
    
    
    return renderingProperties;
}

+(NSDictionary*) recursivePropsScan:(UIView*)view 
{
    if ( view ) {
        NSMutableDictionary* viewMetaDic = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
        // put base properties
        [viewMetaDic setValue: [[view class] description] forKey:@"class"];
        [viewMetaDic setValue:[NSNumber numberWithLong:(void*)view] forKey:@"id"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.frame.origin.x)] forKey:@"frame_x"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.frame.origin.y)] forKey:@"frame_y"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.frame.size.width)] forKey:@"frame_w"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.frame.size.height)] forKey:@"frame_h"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.bounds.size.width)] forKey:@"bounds_w"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.bounds.size.height)] forKey:@"bounds_h"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.bounds.origin.x)] forKey:@"bounds_x"];
        [viewMetaDic setValue:[NSNumber numberWithFloat: handleNaN(view.bounds.origin.y)] forKey:@"bounds_y"];
        // put properties from super classes
        NSMutableArray* viewPropsArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        // put UIGeometry properties
        NSMutableDictionary* uiGeometryPropDic = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
        [uiGeometryPropDic setValue:@"UIGeometry" forKey:@"name"];
        [uiGeometryPropDic setValue:[HVHierarchyScanner UIGeometryProps:view] forKey:@"props"];
        [viewPropsArray addObject:uiGeometryPropDic];
        // put UIRendering
        NSMutableDictionary* uiRenderingPropDic = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
        [uiRenderingPropDic setValue:@"UIViewRendering" forKey:@"name"];
        [uiRenderingPropDic setValue:[HVHierarchyScanner UIViewRenderingProps:view] forKey:@"props"];
        [viewPropsArray addObject:uiRenderingPropDic];
        // put rest 
        Class class = [view class];
        while ( class != [NSObject class] ) {
            NSMutableDictionary* classPropDic = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
            [classPropDic setValue:[HVHierarchyScanner classProperties:class object:view] forKey:@"props"];
            [classPropDic setValue:[class description] forKey:@"name"];
            [viewPropsArray addObject:classPropDic];
            class = [class superclass];
        }
        
        [viewMetaDic setValue:viewPropsArray forKey:@"props"];
        
        NSMutableArray* subViewsArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        for ( UIView* v in [view subviews] ) {
            NSDictionary* subViewDic = [HVHierarchyScanner recursivePropsScan:v];
            if ( subViewDic ) {
                [subViewsArray addObject:subViewDic];
            }
        }
        [viewMetaDic setValue:subViewsArray forKey:@"views"];
        return viewMetaDic;
    } 
    return nil;
}

+(NSArray*) hierarchySnapshot
{
    UIApplication* app = [UIApplication sharedApplication];
    NSMutableArray* windowViews = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    if ( app && app.windows ) {
        for ( UIWindow* window in app.windows ) {
            [windowViews addObject:[HVHierarchyScanner recursivePropsScan:window]];
        }
    }
    return windowViews;
}

@end
