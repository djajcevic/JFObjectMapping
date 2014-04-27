//
//  JFObject.h
//  JFramework
//
//  Created by Denis Jajčević on 31.10.2013..
//  Copyright (c) 2014. Denis Jajčević. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInstanceIdPropertyName @"instanceId"

#define kInstanceDescriptionPropertyName @"instanceDescription"

#import "JFObjectMeta.h"
#import "JFSerializableProtocol.h"


#pragma mark - interface

@interface JFObject : NSObject <JFSerializableProtocol>

@property(strong, nonatomic) NSMutableDictionary *dictionary;

+ (JFObjectMeta *)metaData;

- (JFObjectMeta *)metaData;

- (BOOL)valid;

@property(readonly, nonatomic) NSArray *ignoredSerializationFields;

#pragma mark - shared properties
@property(nonatomic, retain) NSNumber *instanceId;
@property(nonatomic, retain) NSNumber *instanceDescription;

@end
