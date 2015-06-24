#import <UIKit/UIKit.h>

@interface NSWTrafficAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UITabBarController *tabBarController;
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

- (void)createEditableCopyOfDatabaseIfNeeded;
+ (NSString *)pathToDatabase;
- (void)displayDisclaimerIfUserHasNotAccepted;

@end

