# JFObjectMapping

Object to/from JSON/NSDictionary mapping framework

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JFObjectMapping is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "JFObjectMapping"

## Usage

First, import  class and implement +load method, eg.:

```
#import <Foundation/Foundation.h>
#import "NSObject+JFObjectMapping.h"

@class JFTestSubObject;


@interface JFTestObject : NSObject

@property(nonatomic, retain) NSNumber        *instanceId;
@property(nonatomic, retain) NSString        *instanceDescription;
@property(nonatomic, retain) NSString        *testString;
@property(nonatomic, retain) NSNumber        *testNumber;
@property(nonatomic, retain) NSDictionary    *testDictionary;
@property(nonatomic, retain) NSArray         *testArray;
@property(nonatomic, retain) NSSet           *testSet;
@property(nonatomic, retain) JFTestSubObject *testSubObject;

@end

#import "JFTestObject.h"
#import "JFTestSubObject.h"
#import "JFObjectMetaRepository.h"
#import "JFIgnoreSerialization.h"


@implementation JFTestObject

+ (void)load
{
    [super load];
    JFObjectMeta *meta = [[JFObjectMetaRepository defaultRepository]
            registerClass:[self class]];
    [meta mapPropertyName:@"test_id" to:kInstanceIdPropertyName];

    JFIgnoreSerialization *ignoreSerialization = [[JFIgnoreSerialization alloc]
            initWithFieldName:@"testNumber" andTargetClass:[self class]];
    ignoreSerialization.mode = SERIALIZATION_ONLY;
    [meta addSerializationAnnotation:ignoreSerialization];
}

- (void)afterPropertiesSet
{
    NSLog(@"Object populated: %@", self);
}

@end

```

```
#import <Foundation/Foundation.h>
#import "NSObject+JFObjectMapping.h"

@interface JFTestSubObject : NSObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSDate   *date;

@end

#import "JFTestSubObject.h"
#import "JFObjectMetaRepository.h"
#import "JFDateMapping.h"


@implementation JFTestSubObject

+ (void)load
{
    [super load];
    JFObjectMeta *meta = [[JFObjectMetaRepository defaultRepository]
            registerClass:[self class]];

    JFDateMapping *dateMapping = [[JFDateMapping alloc]
            initWithFieldName:@"date" andTargetClass:[self class]];
    [meta addSerializationAnnotation:dateMapping];
}

@end
```

Then you can use these cool features:

```

- (NSDictionary *)toDictionary;

+ (NSArray *)toDictionaryArray:(NSArray *)array;

- (NSData *)toJson;

+ (NSData *)toJsonArray:(NSArray *)array;

- (NSString *)toJsonString;

+ (NSString *)toJsonArrayString:(NSArray *)array;

+ (instancetype)fromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)fromDictionaryArray:(NSArray *)dictionaryArray;

+ (instancetype)fromJson:(NSData *)data;

+ (NSArray *)fromJsonArray:(NSData *)data;

+ (instancetype)fromJsonString:(NSString *)string;

+ (NSArray *)fromJsonArrayString:(NSString *)string;

- (void)afterPropertiesSet;

```

See example (unit tests) for more details.

## Author

Denis Jajčević, denis.jajcevic@gmail.com

## License

JFObjectMapping is available under the MIT license. See the LICENSE file for more info.

