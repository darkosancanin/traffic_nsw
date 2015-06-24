#import <Foundation/Foundation.h>

#define kTrafficReportTypeCurrentConditions 0
#define kTrafficReportTypeRoadWorks 1
#define kTrafficReportTypeSpecialEvents 2

@interface TrafficReport : NSObject {
	NSInteger trafficReportId;
	NSInteger regionId;
	NSInteger typeId;
	NSString *description;
	NSString *descriptionDetails;
	NSString *lanesAffected;
	NSString *lanesClosed;
	NSString *startedTime;
	NSString *updatedTime;
	NSString *ubdReference;
	NSString *impact;
	NSString *attending;
	NSString *from;
	NSString *to;
	NSString *rtaAdvice;
	NSString *otherAdvice;
}

@property (nonatomic) NSInteger trafficReportId;
@property (nonatomic) NSInteger regionId;
@property (nonatomic) NSInteger typeId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *descriptionDetails;
@property (nonatomic, retain) NSString *lanesAffected;
@property (nonatomic, retain) NSString *lanesClosed;
@property (nonatomic, retain) NSString *startedTime;
@property (nonatomic, retain) NSString *updatedTime;
@property (nonatomic, retain) NSString *ubdReference;
@property (nonatomic, retain) NSString *impact;
@property (nonatomic, retain) NSString *attending;
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSString *to;
@property (nonatomic, retain) NSString *rtaAdvice;
@property (nonatomic, retain) NSString *otherAdvice;

+ (NSDictionary *)getDictionaryOfTrafficReportsByRegionId:(NSInteger)regionId;
+ (NSDictionary *)createDictionaryWithTypesAsKeysFromArray:(NSArray *)trafficReports;

@end
