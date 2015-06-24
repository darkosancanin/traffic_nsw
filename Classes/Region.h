#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define kAreaNameSydney @"Sydney"
#define kAreaNameRegional @"Regional"

@interface Region : NSObject {
	NSInteger regionId;
	NSString *name;
	NSString *url;
	NSDate *lastUpdated;
	NSString *area;
}

@property (nonatomic) NSInteger regionId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSString *area;

+ (NSDictionary *)getDictionaryOfRegions;
+ (NSArray *)getArrayOfRegionsByArea:(NSString *)area database:(sqlite3 *)db;

@end
