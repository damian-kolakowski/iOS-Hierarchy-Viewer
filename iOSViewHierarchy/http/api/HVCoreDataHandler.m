//
//  HVCoreDataHandler.m
//  iOSHierarchyViewer
//
//  Created by Damian Kolakowski on 8/21/12.
//
//

#import "JSONKit.h"
#import "HVCoreDataHandler.h"

@implementation HVCoreDataHandler

+ (HVCoreDataHandler *)handler
{
  return [[[HVCoreDataHandler alloc] init] autorelease];
}

- (id)init
{
  self = [super init];
  if (self) {
    contextDictionary = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [contextDictionary release];
  [super dealloc];
}

- (void)pushContext:(NSManagedObjectContext *)context withName:(NSString *)name
{
  [contextDictionary setObject:context forKey:name];
}

- (void)popContext:(NSString*)name
{
  [contextDictionary removeObjectForKey:name];
}

- (NSMutableDictionary*) contextScheme:(NSManagedObjectContext*)context
{
  NSManagedObjectModel* model = [context.persistentStoreCoordinator managedObjectModel];
  if ( model ) {
    NSMutableDictionary* contextModelDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray* entityArray = [[[NSMutableArray alloc]init] autorelease];
    for ( NSEntityDescription* descriptor in model.entities) {
      NSMutableDictionary* entityDictionary = [[[NSMutableDictionary alloc] init] autorelease];
      [entityDictionary setObject:descriptor.name forKey:@"name"];
      [entityDictionary setObject:descriptor.managedObjectClassName forKey:@"class"];
      NSMutableArray* propertiesArray = [[[NSMutableArray alloc]init] autorelease];
      for ( NSPropertyDescription* property in descriptor.properties ) {
        NSMutableDictionary* propertyDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        [propertyDictionary setValue:property.name forKey:@"name"];
        if ( [property isKindOfClass:[NSAttributeDescription class]] ) {
          [propertyDictionary setValue:((NSAttributeDescription*)property).attributeValueClassName forKey:@"type"];
        }
        if ( [property isKindOfClass:[NSRelationshipDescription class]] ) {
          [propertyDictionary setValue:((NSRelationshipDescription*)property).destinationEntity.name forKey:@"type"];
        }
        [propertiesArray addObject:propertyDictionary];
      }
      [entityDictionary setValue:propertiesArray forKey:@"properties"];
      [entityArray addObject:entityDictionary];
    }
    [contextModelDictionary setObject:entityArray forKey:@"entities"];
    return contextModelDictionary;
  }
  return nil;
}

- (BOOL) handleSchemeRequest:(int)socket
{
  NSMutableArray* resultArray = [[[NSMutableArray alloc] init] autorelease];
  for ( NSString* contextName in contextDictionary ) {
    NSManagedObjectContext* context = [contextDictionary objectForKey:contextName];
    NSMutableDictionary* contextModelDictionary = [self contextScheme:context];
    [contextModelDictionary setObject:contextName forKey:@"name"];
    [resultArray addObject:contextModelDictionary];
  }
  return [self writeText:[resultArray JSONString] toSocket:socket];
}

- (BOOL) handleFetchRequest:(int)socket query:(NSDictionary *)query
{
  NSString* entity = [query objectForKey:@"entity"];
  NSString* predicate = [query objectForKey:@"predicate"];
  NSString* contextName = [query objectForKey:@"context"];
  NSManagedObjectContext* context = [contextDictionary objectForKey:contextName];
  if ( !context ) {
    return [self writeText:[[NSDictionary dictionaryWithObject:@"Can't find context" forKey:@"error"] JSONString] toSocket:socket];
  }
  NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
  if ( predicate ) {
    @try {
      request.predicate = [NSPredicate predicateWithFormat:predicate];
    }
    @catch (NSException *exception) {
      return [self writeText:[[NSDictionary dictionaryWithObject:[exception description] forKey:@"error"] JSONString] toSocket:socket];
    }
  }
  request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
  if ( !request.entity ) {
    return [self writeText:[[NSDictionary dictionaryWithObject:@"Can't find entity" forKey:@"error"] JSONString] toSocket:socket];
  }
  NSError* error = nil;
  NSArray* result = nil;
  @try {
    result = [context executeFetchRequest:request error:&error];
  }
  @catch (NSException *exception) {
    return [self writeText:[[NSDictionary dictionaryWithObject:[exception description] forKey:@"error"] JSONString] toSocket:socket];
  }
  if ( result ) {
    NSMutableArray* resultArray = [[[NSMutableArray alloc] init] autorelease];
    for ( NSManagedObject* object in result) {
      NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc]init] autorelease];
      for ( NSPropertyDescription* property in request.entity.properties ) {
        if ( [property isKindOfClass:[NSAttributeDescription class]] ) {
          id value = [object valueForKey:property.name];
          if ( [value isKindOfClass:[NSDate class]]) {
            value = [NSNumber numberWithDouble:[((NSDate*)value) timeIntervalSince1970]];
          }
          if ( [value isKindOfClass:[NSData class]]) {
            value = @"binary";
          }
          [dictionary setValue:value forKey:property.name];
        }
      }
      [resultArray addObject:dictionary];
    }
    NSError* jsonSerializationError;
    NSString* json = [resultArray JSONStringWithOptions:JKSerializeOptionNone error:&jsonSerializationError];
    if ( json ) {
      return [self writeText:[resultArray JSONString] toSocket:socket];
    } else {
      return [self writeText:[[NSDictionary dictionaryWithObject:[jsonSerializationError description] forKey:@"error"] JSONString] toSocket:socket];
    }
  } else {
    return [self writeText:[[NSDictionary dictionaryWithObject:[error description] forKey:@"error"] JSONString] toSocket:socket];
  }
}

- (BOOL)handleRequest:(NSString *)url withHeaders:(NSDictionary *)headers query:(NSDictionary *)query address:(NSString *)address onSocket:(int)socket
{
  if ([super handleRequest:url withHeaders:headers query:query address:address onSocket:socket]) {
    if ([self writeText:@"\r\n" toSocket:socket]) {
      if ( query && [query count] > 0 ) {
        return [self handleFetchRequest:socket query:query];
      } else {
        return [self handleSchemeRequest:socket];
      }
    }
  }
  return NO;
}

@end
