//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFAnnotation.h"
#import "JFSerializationAnnotation.h"

typedef enum {
    ALWAYS,
    SERIALIZATION_ONLY,
    DESERIALIZATION_ONLY
} JFIgnoreSerializationMode;

@interface JFIgnoreSerialization : JFSerializationAnnotation

@property(nonatomic, assign) JFIgnoreSerializationMode mode;

-(BOOL) shouldSerialize;
-(BOOL) shouldDeserialize;

@end