//
//  HVHierarchyScanner.m
//
//  Copyright (c) 2012 Damian Kolakowski. All rights reserved.
//

#import <objc/runtime.h>
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import "HVHierarchyScanner.h"

@implementation HVHierarchyScanner

CGFloat handleNotFinite(CGFloat value)
{
  if (!isfinite(value)) {
    return 1;
  }
  return value;
}

+ (UIView *)recursiveSearchForView:(long)_id parent:(UIView *)parent
{
  if ((void *)parent == (void *)_id) {
    return parent;
  }
  for (UIView *v in [parent subviews]) {
    UIView *result = [HVHierarchyScanner recursiveSearchForView:_id parent:v];
    if (result) {
      return result;
    }
  }
  return nil;
}

+ (UIView *)findViewById:(long)_id
{
  UIApplication *app = [UIApplication sharedApplication];
  if (app) {
    for (UIView *v in [app windows]) {
      UIView *result = [HVHierarchyScanner recursiveSearchForView:_id parent:v];
      if (result) {
        return result;
      }
    }
  }
  return nil;
}

+ (NSString *)UIColorToNSString:(UIColor *)color
{
  if (color) {
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([color CGColor]);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);

    NSString *prefix = @"A???";
    switch (model) {
      case kCGColorSpaceModelCMYK:
        prefix = @"CMYKA";
        break;
      case kCGColorSpaceModelDeviceN:
        prefix = @"DeviceNA";
        break;
      case kCGColorSpaceModelIndexed:
        prefix = @"IndexedA";
        break;
      case kCGColorSpaceModelLab:
        prefix = @"LabA";
        break;
      case kCGColorSpaceModelMonochrome:
        prefix = @"MONOA";
        break;
      case kCGColorSpaceModelPattern:
        prefix = @"APattern";
        break;
      case kCGColorSpaceModelRGB:
        prefix = @"RGBA";
        break;
      case kCGColorSpaceModelUnknown:
        prefix = @"A???";
        break;
    }
    size_t n = CGColorGetNumberOfComponents([color CGColor]);
    const CGFloat *componentsArray = CGColorGetComponents([color CGColor]);

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:n];
    //[array addObject:[NSNumber numberWithInt:(int)(CGColorGetAlpha([color CGColor])*255.0f)]];
    for (size_t i = 0; i < n; ++i) {
      [array addObject:[NSNumber numberWithInt:(int)(componentsArray[i] * 255.0f)]];
    }
    NSString *components = [array componentsJoinedByString:@","];
    [array release];

    return [NSString stringWithFormat:@"%@(%@)", prefix, components];
  }
  return @"nil";
}

static NSString* NSStringFromCGAffineTransform2(CGAffineTransform transform)
{
  return [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f", 
          transform.a, 
          transform.b, 
          transform.c, 
          transform.d, 
          transform.tx, 
          transform.ty];
}

static NSString* NSStringFromCATransform3D(CATransform3D transform)
{
  return [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f",
     (transform.m11),
     (transform.m12),
     (transform.m13),
     (transform.m14),
     (transform.m21),
     (transform.m22),
     (transform.m23),
     (transform.m24),
     (transform.m31),
     (transform.m32),
     (transform.m33),
     (transform.m34),
     (transform.m41),
     (transform.m42),
     (transform.m43),
     (transform.m44)
     ];
}

+ (NSMutableArray *)classProperties:(Class)class object:(NSObject *)obj
{
  unsigned int outCount, i;
  objc_property_t *properties = class_copyPropertyList(class, &outCount);
  NSMutableArray *propertiesArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];

  // handle UITextInputTraits properties which aren't KVO compilant
  BOOL conformsToUITextInputTraits = [class conformsToProtocol:@protocol(UITextInputTraits)];

  for (i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];

    NSMutableDictionary *propertyDescription = [[NSMutableDictionary alloc] initWithCapacity:2];

    NSString *propertyName = [[[NSString alloc] initWithCString:property_getName(property) encoding:[NSString defaultCStringEncoding]] autorelease];

    if (conformsToUITextInputTraits) {
      if (protocol_getMethodDescription(@protocol(UITextInputTraits), NSSelectorFromString(propertyName), NO, YES).name != NULL) {
        continue;
      }
      if ([@"secureTextEntry" isEqualToString:propertyName]) {
        continue;
      }
    }

    NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:[NSString defaultCStringEncoding]];
    [propertyDescription setValue:propertyName forKey:@"name"];

    NSArray *attributes = [propertyType componentsSeparatedByString:@","];
    NSString *typeAttribute = [attributes objectAtIndex:0];
    NSString *type = [typeAttribute substringFromIndex:1];
    const char *rawPropertyType = [type UTF8String];

    BOOL readValue = NO;
    BOOL checkOnlyIfNil = NO;

    if (strcmp(rawPropertyType, @encode(float)) == 0) {
      [propertyDescription setValue:@"float" forKey:@"type"];
      readValue = YES;
    } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
      [propertyDescription setValue:@"double" forKey:@"type"];
      readValue = YES;
    } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
      [propertyDescription setValue:@"int" forKey:@"type"];
      readValue = YES;
    } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
      [propertyDescription setValue:@"long" forKey:@"type"];
      readValue = YES;
    } else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
      [propertyDescription setValue:@"BOOL" forKey:@"type"];
      readValue = NO;
      NSNumber *propertyValue;
      @try {
        propertyValue = [obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:([propertyValue boolValue] ? @"YES" : @"NO") forKey:@"value"];
    } else if (strcmp(rawPropertyType, @encode(char)) == 0) {
      [propertyDescription setValue:@"char" forKey:@"type"];
    } else if ( type && ( [type hasPrefix:@"{CGRect="] ) ) {
      readValue = NO;
      NSValue *propertyValue;
      @try {
        propertyValue = [obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:[NSString stringWithFormat:@"%@", NSStringFromCGRect([propertyValue CGRectValue])] forKey:@"value"];
      [propertyDescription setValue:@"CGRect" forKey:@"type"];
    } else if ( type && ( [type hasPrefix:@"{CGPoint="] ) ) {
      readValue = NO;
      NSValue *propertyValue;
      @try {
        propertyValue = [obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:[NSString stringWithFormat:@"%@", NSStringFromCGPoint([propertyValue CGPointValue])] forKey:@"value"];
      [propertyDescription setValue:@"CGPoint" forKey:@"type"];
    } else if ( type && ( [type hasPrefix:@"{CGSize="] ) ) {
      readValue = NO;
      NSValue *propertyValue;
      @try {
        propertyValue = [obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:[NSString stringWithFormat:@"%@", NSStringFromCGSize([propertyValue CGSizeValue])] forKey:@"value"];
      [propertyDescription setValue:@"CGSize" forKey:@"type"];
    } else if ( type && ( [type hasPrefix:@"{CGAffineTransform="] ) ) {
      readValue = NO;
      CGAffineTransform *propertyValue;
      @try {
        propertyValue = (CGAffineTransform*)[obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:[NSString stringWithFormat:@"%@", NSStringFromCGAffineTransform2(*propertyValue)] forKey:@"value"];
      [propertyDescription setValue:@"CGAffineTransform" forKey:@"type"];
    } else if ( type && ( [type hasPrefix:@"{CATransform3D="] ) ) {
      readValue = NO;
      CATransform3D *propertyValue;
      @try {
        propertyValue = (CATransform3D*)[obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      [propertyDescription setValue:[NSString stringWithFormat:@"%@", NSStringFromCATransform3D(*propertyValue)] forKey:@"value"];
      [propertyDescription setValue:@"CATransform3D" forKey:@"type"];
    } else if (type && [type hasPrefix:@"@"] && [type length] > 3) {
      readValue = YES;
      checkOnlyIfNil = YES;
      NSString *typeClassName = [type substringWithRange:NSMakeRange(2, [type length] - 3)];
      [propertyDescription setValue:typeClassName forKey:@"type"];
      if ([typeClassName isEqualToString:[[UIColor class] description]]) {
        readValue = NO;
        id propertyValue;
        @try {
          propertyValue = [obj valueForKey:propertyName];
        }
        @catch (NSException *exception) {
          propertyValue = nil;
        }

        [propertyDescription setValue:(propertyValue ? [HVHierarchyScanner UIColorToNSString:propertyValue] : @"nil") forKey:@"value"];
      }
      if ([typeClassName isEqualToString:[[NSString class] description]]) {
        checkOnlyIfNil = NO;
      }
      if ([typeClassName isEqualToString:[[UIFont class] description]]) {
        checkOnlyIfNil = NO;
      }
    } else {
      [propertyDescription setValue:propertyType forKey:@"type"];
    }
    if (readValue) {
      id propertyValue;
      @try {
        propertyValue = [obj valueForKey:propertyName];
      }
      @catch (NSException *exception) {
        propertyValue = nil;
      }
      if (checkOnlyIfNil) {
        [propertyDescription setValue:(propertyValue != nil ? @"OBJECT" : @"nil") forKey:@"value"];
      } else {
        [propertyDescription setValue:(propertyValue != nil ? [NSString stringWithFormat:@"%@", propertyValue] : @"nil") forKey:@"value"];
      }
    }
    [propertiesArray addObject:propertyDescription];
    [propertyType release];
    [propertyDescription release];
  }
  free(properties);
  return propertiesArray;
}

+ (NSArray *)UIGeometryProperties:(UIView *)view
{
  NSMutableArray *properties = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];

  NSDictionary *frame = [NSDictionary dictionaryWithObjectsAndKeys:@"frame", @"name", @"CGRect", @"type", NSStringFromCGRect(view.frame), @"value", nil];
  [properties addObject:frame];

  NSDictionary *bounds = [NSDictionary dictionaryWithObjectsAndKeys:@"bounds", @"name", @"CGRect", @"type", NSStringFromCGRect(view.bounds), @"value", nil];
  [properties addObject:bounds];

  NSDictionary *center = [NSDictionary dictionaryWithObjectsAndKeys:@"center", @"name", @"CGPoint", @"type", NSStringFromCGPoint(view.center), @"value", nil];
  [properties addObject:center];
  
  NSDictionary *transform = [NSDictionary dictionaryWithObjectsAndKeys:@"transform", @"name", @"CGAffineTransform", @"type", NSStringFromCGAffineTransform2(view.transform), @"value", nil];
  [properties addObject:transform];
  
  NSDictionary *layerTransform = [NSDictionary dictionaryWithObjectsAndKeys:@"layer.transform", @"name", @"CATransform3D", @"type", NSStringFromCATransform3D(view.layer.transform), @"value", nil];
  [properties addObject:layerTransform];

  return properties;
}

+ (NSArray *)UIViewRenderingProperties:(UIView *)view
{
  NSMutableArray *properties = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];

  NSDictionary *clipToBounds = [NSDictionary dictionaryWithObjectsAndKeys:@"clipToBounds", @"name", @"BOOL", @"type", view.clipsToBounds ? @"YES" : @"NO", @"value", nil];
  [properties addObject:clipToBounds];

  NSDictionary *backgroundColor = [NSDictionary dictionaryWithObjectsAndKeys:@"backgroundColor", @"name", @"UIColor", @"type", [HVHierarchyScanner UIColorToNSString:view.backgroundColor], @"value", nil];
  [properties addObject:backgroundColor];

  NSDictionary *alpha = [NSDictionary dictionaryWithObjectsAndKeys:@"alpha", @"name", @"CGFloat", @"type", [NSString stringWithFormat:@"%f", view.alpha], @"value", nil];
  [properties addObject:alpha];

  NSDictionary *opaque = [NSDictionary dictionaryWithObjectsAndKeys:@"opaque", @"name", @"BOOL", @"type", view.opaque ? @"YES" : @"NO", @"value", nil];
  [properties addObject:opaque];

  NSDictionary *hidden = [NSDictionary dictionaryWithObjectsAndKeys:@"hidden", @"name", @"BOOL", @"type", view.hidden ? @"YES" : @"NO", @"value", nil];
  [properties addObject:hidden];

  NSDictionary *contentMode = [NSDictionary dictionaryWithObjectsAndKeys:@"contentMode", @"name", @"UIViewContentMode", @"type", [NSString stringWithFormat:@"%d", view.contentMode], @"value", nil];
  [properties addObject:contentMode];

  NSDictionary *clearContextBeforeDrawing = [NSDictionary dictionaryWithObjectsAndKeys:@"clearsContextBeforeDrawing", @"name", @"BOOL", @"type", view.clearsContextBeforeDrawing ? @"YES" : @"NO", @"value", nil];
  [properties addObject:clearContextBeforeDrawing];

  
  return properties;
}

+ (NSDictionary *)recursivePropertiesScan:(UIView *)view
{
  if (view) {
    NSMutableDictionary *viewDescription = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    // put base properties
    NSString *className = [[view class] description];
    NSString *objectName = view.accessibilityLabel ? [NSString stringWithFormat:@"%@ : %@", view.accessibilityLabel, className] : className;
    [viewDescription setValue:objectName forKey:@"class"];
    [viewDescription setValue:[NSNumber numberWithLong:(long)view] forKey:@"id"];
    
    [viewDescription setValue:NSStringFromCATransform3D(view.layer.transform) forKey:@"layer_transform"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.bounds.origin.x)] forKey:@"layer_bounds_x"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.bounds.origin.y)] forKey:@"layer_bounds_y"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.bounds.size.width)] forKey:@"layer_bounds_w"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.bounds.size.height)] forKey:@"layer_bounds_h"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.position.x)] forKey:@"layer_position_x"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.position.y)] forKey:@"layer_position_y"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.anchorPoint.x)] forKey:@"layer_anchor_x"];
    [viewDescription setValue:[NSNumber numberWithFloat:handleNotFinite(view.layer.anchorPoint.y)] forKey:@"layer_anchor_y"];

    // put properties from super classes
    NSMutableArray *properties = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];

    // put UIGeometry properties
    NSMutableDictionary *geometryProperties = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [geometryProperties setValue:@"UIGeometry" forKey:@"name"];
    [geometryProperties setValue:[HVHierarchyScanner UIGeometryProperties:view] forKey:@"props"];
    [properties addObject:geometryProperties];

    // put UIRendering
    NSMutableDictionary *renderingProperties = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [renderingProperties setValue:@"UIViewRendering" forKey:@"name"];
    [renderingProperties setValue:[HVHierarchyScanner UIViewRenderingProperties:view] forKey:@"props"];
    [properties addObject:renderingProperties];

    // put rest
    Class class = [view class];
    while (class != [NSObject class]) {
      NSMutableDictionary *classProperties = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
      [classProperties setValue:[HVHierarchyScanner classProperties:class object:view] forKey:@"props"];
      [classProperties setValue:[class description] forKey:@"name"];
      [properties addObject:classProperties];
      class = [class superclass];
    }
    
    // put CALayer
    NSMutableDictionary *layerProperties = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [layerProperties setValue:@"CALayer" forKey:@"name"];
    [layerProperties setValue:[HVHierarchyScanner classProperties:[CALayer class] object:view.layer] forKey:@"props"];
    [properties addObject:layerProperties];
    
    [viewDescription setValue:properties forKey:@"props"];
    
    NSMutableArray *subViewsArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    for (UIView *subview in [view subviews]) {
      NSDictionary *subviewDictionary = [HVHierarchyScanner recursivePropertiesScan:subview];
      if (subviewDictionary) {
        [subViewsArray addObject:subviewDictionary];
      }
    }
    [viewDescription setValue:subViewsArray forKey:@"views"];
    return viewDescription;
  }
  return nil;
}

+ (NSArray *)hierarchySnapshot
{
  UIApplication *app = [UIApplication sharedApplication];
  NSMutableArray *windowViews = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];

  if (app && app.windows) {
    void (^gatherProperties)() = ^() {
      for (UIWindow *window in app.windows) {
        NSDictionary* windowDictionary = [HVHierarchyScanner recursivePropertiesScan:window];
        [windowDictionary setValue:[NSString stringWithFormat:@"/preview?id=%ld", (long)window] forKey:@"preview"];
        [windowViews addObject:windowDictionary];
      }
    };

    //! don't want to lock out our thread
    if ([NSThread mainThread] == [NSThread currentThread]) {
      gatherProperties();
    } else {
      dispatch_sync(dispatch_get_main_queue(), gatherProperties);
    }
  }
  return windowViews;
}

@end
