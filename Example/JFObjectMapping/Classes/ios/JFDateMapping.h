//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFSerializationAnnotation.h"


@interface JFDateMapping : JFSerializationAnnotation

@property(nonatomic, retain) __block NSString *format;

@end