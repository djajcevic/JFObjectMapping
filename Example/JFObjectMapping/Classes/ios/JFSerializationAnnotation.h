//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFAnnotation.h"

typedef id(^MappingBlock)(id value, BOOL inverse);

@interface JFSerializationAnnotation : JFAnnotation

@property(nonatomic, retain) NSString   *mapsTo;
@property(nonatomic, copy) MappingBlock mappingBlock;

@end