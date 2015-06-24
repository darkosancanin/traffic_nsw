#import "UpdateTrafficReportsOperation.h"
#import "RegexKitLite.h"
#import "TrafficReport.h"
#import "sqlite3.h"
#import "NSWTrafficAppDelegate.h"

@implementation UpdateTrafficReportsOperation

@synthesize region;
@synthesize delegate;

- (id)initWithRegion:(Region*)regionToUpdate;
{
    if (![super init]) return nil;
    self.region = regionToUpdate;
    return self;
}

- (void)dealloc {
    [region release];
    [super dealloc];
}

- (void)main {
	@try {
		[self updateTrafficReportsForRegion];
		[delegate performSelectorOnMainThread:@selector(trafficReportsDidUpdateAt:) withObject:self.region.lastUpdated waitUntilDone:NO];
	}
	@catch (NSException *e) {
		[delegate performSelectorOnMainThread:@selector(trafficReportsUpdateOperationDidFailWithReason:) withObject:[e reason] waitUntilDone:NO];
	}
}

- (void)updateTrafficReportsForRegion{
	NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:self.region.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
	NSError *error;
	NSURLResponse *response;
	NSData *htmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSMutableString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]; 
	
	if(error != nil){
		[delegate performSelectorOnMainThread:@selector(trafficReportsUpdateOperationConnectionDidFailWithReason:) withObject:[error localizedDescription] waitUntilDone:NO];
		return;
	}
	
	if(htmlData == nil || html.length < 10){
		[delegate performSelectorOnMainThread:@selector(trafficReportsUpdateOperationConnectionDidFailWithReason:) withObject:nil waitUntilDone:NO];
		return;
	}
	
	html = [NSMutableString stringWithString:html];
	[html replaceOccurrencesOfRegex:@"\\n" withString:@""];

	NSString *roadWorksHtml = [[html componentsMatchedByRegex:@"<div\\sclass=\"events_title\">\\s\\sRoad\\sWorks(.*?)<div\\sclass=\"events_title\""] objectAtIndex:0];
	NSString *specialEventsHtml = [[html componentsMatchedByRegex:@"div\\sclass=\"events_title\">\\s\\sSpecial\\sEvents(.*?)<div\\sclass=\"events_title\""] objectAtIndex:0];
	
	NSArray *currentConditionEntries = [html componentsMatchedByRegex:@"<div\\sclass=\"incident\">(.*?)</table>\\s\\s</div>"];
	NSArray *roadWorkEntries = [roadWorksHtml componentsMatchedByRegex:@"<div\\sclass=\"planned_event\">(.*?)<!--\\splanned_event\\s-->"];
	NSArray *specialEventEntries = [specialEventsHtml componentsMatchedByRegex:@"<div\\sclass=\"planned_event\">(.*?)<!--\\splanned_event\\s-->"];
	
	NSArray *trafficReports = [self createTrafficReportsFromEntries:currentConditionEntries ofType:kTrafficReportTypeCurrentConditions];
	trafficReports = [trafficReports  arrayByAddingObjectsFromArray:[self createTrafficReportsFromEntries:roadWorkEntries ofType:kTrafficReportTypeRoadWorks]];
	trafficReports = [trafficReports  arrayByAddingObjectsFromArray:[self createTrafficReportsFromEntries:specialEventEntries ofType:kTrafficReportTypeSpecialEvents]];
	
	[self insertTrafficReports:trafficReports];
}

- (NSArray *)createTrafficReportsFromEntries:(NSArray *)entries ofType:(NSInteger)typeId{
	NSMutableArray *trafficReports = [[NSMutableArray alloc] init];
	for(NSString *entry in entries){
		TrafficReport *trafficReport = [[TrafficReport alloc] init];
		trafficReport.regionId = self.region.regionId;
		trafficReport.typeId = typeId;
		trafficReport.rtaAdvice = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">RTA\\sadvice:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		trafficReport.otherAdvice = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">Other\\sadvice:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		trafficReport.lanesClosed = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\"\\s>\\s\\sLanes\\sclosed:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		trafficReport.lanesAffected = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\"\\s>\\sLanes\\sAffected:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		
		if(typeId == kTrafficReportTypeCurrentConditions){
			trafficReport.description = [self getMatchAtElement:1 fromString:entry usingRegex:@"<span\\sclass=\"ubd\">(.*?)</span>(.*?)</div>"];
			trafficReport.descriptionDetails = [self getFirstMatchFromString:entry usingRegex:@"<div\\sclass=\"type\">(.*?)</div>"];
			trafficReport.attending = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">Attending:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
			trafficReport.ubdReference = [self getFirstMatchFromString:entry usingRegex:@"<span\\sclass=\"ubd\">UBD: (.*?)</span>"];
			trafficReport.startedTime = [self getFirstMatchFromString:entry usingRegex:@"<div\\sclass=\"startdate\">Started\\sat\\s\\s(.*?)</div>"];
			trafficReport.updatedTime = [self getFirstMatchFromString:entry usingRegex:@"</span>(.*?)</span>\\s\\s<div\\sclass=\"location\">"];
			trafficReport.impact = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">Impact:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		}
		
		if(typeId == kTrafficReportTypeRoadWorks || typeId == kTrafficReportTypeSpecialEvents){
			
			trafficReport.description = [self getFirstMatchFromString:entry usingRegex:@"<div\\sclass=\"type\">(.*?)</div>"];
			trafficReport.descriptionDetails = [self getFirstMatchFromString:entry usingRegex:@"<div\\sclass=\"location\">(.*?)</div>"];
			trafficReport.from = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">From:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
			trafficReport.to = [self getFirstMatchFromString:entry usingRegex:@"<td\\sclass=\"detail_head\">To:</td>\\s\\s<td\\sclass=\"detail\">(.*?)</td>"];
		}
		
		if(trafficReport.description == nil){ trafficReport.description = @""; };
		if([trafficReport.descriptionDetails isMatchedByRegex:@"Road works"]){
			trafficReport.descriptionDetails = @"";
		}
		if(trafficReport.descriptionDetails == nil){ trafficReport.descriptionDetails = @""; };
		if(trafficReport.lanesAffected == nil){ trafficReport.lanesAffected = @""; };
		if(trafficReport.lanesClosed == nil){ trafficReport.lanesClosed = @""; };
		if(trafficReport.startedTime == nil){ trafficReport.startedTime = @""; };
		if(trafficReport.updatedTime == nil){ trafficReport.updatedTime = @""; };
		if(trafficReport.ubdReference == nil){ trafficReport.ubdReference = @""; };
		if(trafficReport.impact == nil){ trafficReport.impact = @""; };
		if(trafficReport.attending == nil){ trafficReport.attending = @""; };
		if(trafficReport.from == nil){ trafficReport.from = @""; };
		if(trafficReport.to == nil){ trafficReport.to = @""; };
		if(trafficReport.rtaAdvice == nil){ trafficReport.rtaAdvice = @""; };
		if(trafficReport.otherAdvice == nil){ trafficReport.otherAdvice = @""; };
		
		[trafficReports addObject:trafficReport];
		[trafficReport release];
	}
	
	return [trafficReports autorelease];
}


- (NSString *)getMatchAtElement:(NSInteger)element fromString:(NSString*)string usingRegex:(NSString *)regex{
	NSArray *matchArray = [string captureComponentsMatchedByRegex:regex];
	NSInteger count = [matchArray count];
	if(count > element){
		NSMutableString *match = [matchArray objectAtIndex:element + 1];
		match = [NSMutableString stringWithString:match];
		[match replaceOccurrencesOfRegex:@"<br>" withString:@"\n"];
		[match replaceOccurrencesOfRegex:@"<(.|\\n)*?>" withString:@""];
		[match replaceOccurrencesOfRegex:@"&#032;" withString:@" "];
		[match replaceOccurrencesOfRegex:@"  " withString:@" "];
		[match replaceOccurrencesOfRegex:@"^[ \\t]+|[ \\t]+$" withString:@""];
		return match;
	}
	return @"";
}

- (NSString *)getFirstMatchFromString:(NSString*)string usingRegex:(NSString *)regex{
	return [self getMatchAtElement:0 fromString:string usingRegex:regex];
}

- (void)insertTrafficReports:(NSArray *)trafficReports{
	sqlite3 *database;
	const char *deleteSQL = "DELETE FROM TrafficReports WHERE RegionId = ?";
	sqlite3_stmt *deleteStatement;
	sqlite3_stmt *insertStatement;
	sqlite3_stmt *updateStatement;
	
	if (sqlite3_open([[NSWTrafficAppDelegate pathToDatabase] UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, deleteSQL, -1, &deleteStatement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(deleteStatement, 1, self.region.regionId);
	if (SQLITE_DONE != sqlite3_step(deleteStatement)){
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	}

	static char *insertSQL = "INSERT INTO TrafficReports ([Description],DescriptionDetails,LanesAffected,LanesClosed,StartedTime,UpdatedTime,UBDReference,Impact,Attending,[From],[To],RTAAdvice,OtherAdvice,RegionId,TypeId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	if (sqlite3_prepare_v2(database, insertSQL, -1, &insertStatement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
		
	for(TrafficReport *trafficReport in trafficReports){
		sqlite3_bind_text(insertStatement, 1, [trafficReport.description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 2, [trafficReport.descriptionDetails UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 3, [trafficReport.lanesAffected UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 4, [trafficReport.lanesClosed UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 5, [trafficReport.startedTime UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 6, [trafficReport.updatedTime UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 7, [trafficReport.ubdReference UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 8, [trafficReport.impact UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 9, [trafficReport.attending UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 10, [trafficReport.from UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 11, [trafficReport.to UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 12, [trafficReport.rtaAdvice UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStatement, 13, [trafficReport.otherAdvice UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(insertStatement, 14, trafficReport.regionId);
		sqlite3_bind_int(insertStatement, 15, trafficReport.typeId);
	
		int success = sqlite3_step(insertStatement);
		
		if (success != SQLITE_OK && success != SQLITE_DONE) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_reset(insertStatement);
	}
	
	static char *updateSQL = "UPDATE Regions SET LastUpdated = ? WHERE Id = ?";
	if (sqlite3_prepare_v2(database, updateSQL, -1, &updateStatement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	NSDate *lastUpdated = [NSDate date];
	sqlite3_bind_double(updateStatement, 1, [lastUpdated timeIntervalSince1970]);
	sqlite3_bind_int(updateStatement, 2, self.region.regionId);
	
	if (SQLITE_DONE != sqlite3_step(updateStatement)){
		NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_finalize(updateStatement);
	sqlite3_finalize(deleteStatement);
	sqlite3_finalize(insertStatement);
	
	if (sqlite3_close(database) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
	}
	
	self.region.lastUpdated = lastUpdated;
}

@end
