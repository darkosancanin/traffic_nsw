#import "Camera.h"
#import "NSWTrafficAppDelegate.h"
#import "sqlite3.h"

@implementation Camera

@synthesize cameraId;
@synthesize regionId;
@synthesize name;
@synthesize description;
@synthesize url;

+ (NSArray *)getArrayOfCamerasByRegionId:(NSInteger)regionId{
	NSMutableArray *cameras = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if (sqlite3_open([[NSWTrafficAppDelegate pathToDatabase] UTF8String], &database) == SQLITE_OK) {
		const char *sql = "SELECT Id,Name,Description,URL FROM Cameras WHERE RegionId=?";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement, 1, regionId);
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Camera *camera = [[Camera alloc] init];        
				int primaryKey = sqlite3_column_int(statement, 0);
				camera.cameraId = primaryKey;
				camera.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				camera.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				camera.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				[cameras addObject:camera];
				[camera release];
			}
		}
		sqlite3_finalize(statement);
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	
	if (sqlite3_close(database) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
	}
	
	return [cameras autorelease];
}

- (void)dealloc {
	[name release];
	[description release];
	[url release];
	[super dealloc];
}

@end
