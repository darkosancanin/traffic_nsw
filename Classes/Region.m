#import "Region.h"
#import "sqlite3.h"
#import "NSWTrafficAppDelegate.h"

@implementation Region

@synthesize regionId;
@synthesize name;
@synthesize url;
@synthesize lastUpdated;
@synthesize area;

+ (NSDictionary *)getDictionaryOfRegions{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	sqlite3 *database;
	if (sqlite3_open([[NSWTrafficAppDelegate pathToDatabase] UTF8String], &database) == SQLITE_OK) {
		[dictionary setValue:[Region getArrayOfRegionsByArea:kAreaNameSydney database:database] forKey:kAreaNameSydney];
		[dictionary setValue:[Region getArrayOfRegionsByArea:kAreaNameRegional database:database] forKey:kAreaNameRegional];
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	if (sqlite3_close(database) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
	}
	
	return [dictionary autorelease];
}

+ (NSArray *)getArrayOfRegionsByArea:(NSString *)area database:(sqlite3 *)db{
	
	NSMutableArray *regions = [[NSMutableArray alloc] init];
	const char *sql = "SELECT Id,Name,URL,LastUpdated FROM Regions WHERE Area=?";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [area UTF8String], -1, SQLITE_TRANSIENT);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Region *region = [[Region alloc] init];        
			int primaryKey = sqlite3_column_int(statement, 0);
			region.regionId = primaryKey;
			region.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
			region.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			region.lastUpdated = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 3)];
			region.area = area;
			[regions addObject:region];
			[region release];
		}
	}
	sqlite3_finalize(statement);
	return [regions autorelease]; 
}

@end
