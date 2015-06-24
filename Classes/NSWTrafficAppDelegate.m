#import "NSWTrafficAppDelegate.h"
#import "TrafficReportsRegionsController.h"
#import "DisclaimerController.h"

@implementation NSWTrafficAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize operationQueue;

- (id)init
{
    if (![super init]) return nil;
    operationQueue = [[NSOperationQueue alloc] init];
    return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self createEditableCopyOfDatabaseIfNeeded];
	
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
	
	[self displayDisclaimerIfUserHasNotAccepted];
}

- (void)displayDisclaimerIfUserHasNotAccepted{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL userHasAcceptedDisclaimer = [userDefaults boolForKey:@"UserHasAcceptedDisclaimer"];
	if(userHasAcceptedDisclaimer == NO){
		DisclaimerController *disclaimerController = [[DisclaimerController alloc] initWithNibName:@"Disclaimer" bundle:nil];
		[tabBarController presentModalViewController:disclaimerController animated:NO];
		[disclaimerController release];
	}
}

- (void)createEditableCopyOfDatabaseIfNeeded{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"nswtraffic.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"nswtraffic.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (NSString *)pathToDatabase{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"nswtraffic.sqlite"];
}


- (void)dealloc {
	[operationQueue release];
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end
