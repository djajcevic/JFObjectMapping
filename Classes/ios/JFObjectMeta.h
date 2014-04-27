//
//  JFObjectMeta.h
//  JFObjectMapping
//
//  Created by Denis Jajčević on 16.9.2013..
// Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "objc/runtime.h"

#define kSerializationPropertyArrayItemsClassKey @"SerializationPropertyArrayItemsClassKey"
#define kSerializationPropertyMappingKey @"SerializationPropertyMapping"

@interface JFObjectMeta : NSObject

@property(assign, nonatomic) Class               clazz;
@property(strong, nonatomic) NSArray             *propertyNames;
@property(strong, nonatomic) NSArray             *propertyClasses;
@property(strong, nonatomic) NSMutableDictionary *propertyAttributes;

- (id)initWithClass:(Class)clazz;

- (id)initWithClass:(Class)clazz ignoreFields:(NSArray *)fieldsToIgnore;

- (void)populatePropertyNames:(NSMutableArray *)propertyArray andPropertyClasses:(NSMutableArray *)propertyClasses
                     forClass:(Class)clazz andIgnoreProperties:(NSArray *)ignoredProperties;

- (Class)classForPropertyNamed:(NSString *)propertyName;

+ (NSArray *)itemClasses:(NSArray *)array;

- (void)mapPropertyName:(NSString *)instancePropertyName to:(NSString *)propertyName;

@end
