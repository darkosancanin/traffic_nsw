#import "TrafficReport.h"
#import "sqlite3.h"
#import "NSWTrafficAppDelegate.h"

@implementation TrafficReport

@synthesize trafficReportId;
@synthesize regionId;
@synthesize typeId;
@synthesize description;
@synthesize descriptionDetails;
@synthesize lanesAffected;
@synthesize lanesClosed;
@synthesize startedTime;
@synthesize updatedTime;
@synthesize ubdReference;
@synthesize impact;
@synthesize attending;
@synthesize from;
@synthesize to;
@synthesize rtaAdvice;
@synthesize otherAdvice;

+ (NSDictionary *)getDictionaryOfTrafficReportsByRegionId:(NSInteger)regionId{
	NSMutableArray *trafficReports = [[NSMutableArray alloc] init];
	const char *sql = "SELECT Id,TypeId,[Description],DescriptionDetails,LanesAffected,LanesClosed,StartedTime,UpdatedTime,UBDReference,Impact,Attending,[From],[To],RTAAdvice,OtherAdvice FROM TrafficReports WHERE RegionId = ?";
	sqlite3 *database;
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[NSWTrafficAppDelegate pathToDatabase] UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, regionId);
			while (sqlite3_step(statement) == SQLITE_ROW) {
				TrafficReport *trafficReport = [[TrafficReport alloc] init];        
				trafficReport.trafficReportId = sqlite3_column_int(statement, 0);
				trafficReport.typeId = sqlite3_column_int(statement, 1);
                trafficReport.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                trafficReport.descriptionDetails = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                trafficReport.lanesAffected = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                trafficReport.lanesClosed = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                trafficReport.startedTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                trafficReport.updatedTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                trafficReport.ubdReference = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                trafficReport.impact = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                trafficReport.attending = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                trafficReport.from = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                trafficReport.to = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                trafficReport.rtaAdvice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                trafficReport.otherAdvice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
				trafficReport.regionId = regionId;
                [trafficReports addObject:trafficReport];
                [trafficReport release];
            }
		}
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_finalize(statement);
	if (sqlite3_close(database) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
	}
	
	NSDictionary *dictionary = [TrafficReport createDictionaryWithTypesAsKeysFromArray:trafficReports]; 
	[trafficReports release];
	
	return dictionary;
}
	
+ (NSDictionary *)createDictionaryWithTypesAsKeysFromArray:(NSArray *)trafficReports{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	NSMutableArray *currentConditions = [[NSMutableArray alloc] init];
	NSMutableArray *roadWorks = [[NSMutableArray alloc] init];
	NSMutableArray *specialEvents = [[NSMutableArray alloc] init];
	[dictionary setObject:currentConditions forKey:[NSNumber numberWithInteger:kTrafficReportTypeCurrentConditions]];
	[dictionary setObject:roadWorks forKey:[NSNumber numberWithInteger:kTrafficReportTypeRoadWorks]];
	[dictionary setObject:specialEvents forKey:[NSNumber numberWithInteger:kTrafficReportTypeSpecialEvents]];
	[currentConditions release];
	[roadWorks release];
	[specialEvents release];
	
	for(TrafficReport *trafficReport in trafficReports){
		[[dictionary objectForKey:[NSNumber numberWithInteger:trafficReport.typeId]] addObject:trafficReport];
	}	
	
	return [dictionary autorelease];
}

- (void)dealloc {
	[description release];
	[descriptionDetails release];
	[lanesAffected release];
	[lanesClosed release];
	[startedTime release];
	[updatedTime release];
	[ubdReference release];
	[impact release];
	[attending release];
	[from release];
	[to release];
	[rtaAdvice release];
	[otherAdvice release];
	[super dealloc];
}

@end
