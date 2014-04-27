# JFObjectMapping

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JFObjectMapping is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "JFObjectMapping"

## Usage

First, update your model to extend JFObject class and implement +load method, eg.:

```
#import "JFObject.h"

@class JFTestSubObject;


@interface JFTestObject : JFObject

@property(nonatomic, retain) NSString        *testString;
@property(nonatomic, retain) NSNumber        *testNumber;
@property(nonatomic, retain) NSDictionary    *testDictionary;
@property(nonatomic, retain) NSArray         *testArray;
@property(nonatomic, retain) NSSet           *testSet;
@property(nonatomic, retain) JFTestSubObject *testSubObject;

@end

@implementation JFTestObject

+ (void)load
{
    [super load];
    [[self metaData]
            mapPropertyName:@"test_id" to:kInstanceIdPropertyName];
}

- (void)afterPropertiesSet
{
    [super afterPropertiesSet];
    NSLog(@"Object populated: %@", self);
}

@end

@interface JFTestSubObject : JFObject

@property(nonatomic, retain) NSString *title;

@end

@implementation JFTestSubObject

+ (void)load
{
    [super load];
}

@end
```

Then you can use these cool features:

```
@protocol JFSerializableProtocol <NSObject>

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

@end
```

See example (unit tests) for more details.

## Author

Denis Jajčević, denis.jajcevic@gmail.com

## License

JFObjectMapping is available under the MIT license. See the LICENSE file for more info.

