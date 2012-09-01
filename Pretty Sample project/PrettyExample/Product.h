//
//  Product.h
//  PrettyExample
//
//  Created by Damian Kolakowski on 9/1/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * price;

@end
