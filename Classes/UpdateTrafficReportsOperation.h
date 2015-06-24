#import <Foundation/Foundation.h>
#import "Region.h"
#import "UpdateTrafficReportsOperationDelegate.h"

@interface UpdateTrafficReportsOperation : NSOperation {
    Region *region;
    NSObject<UpdateTrafficReportsOperationDelegate> *delegate;
}

@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSObject<UpdateTrafficReportsOperationDelegate> *delegate;

- (id)initWithRegion:(Region*)region;
- (NSArray *)createTrafficReportsFromEntries:(NSArray *)entries ofType:(NSInteger)typeId;
- (void)updateTrafficReportsForRegion;
- (NSString *)getFirstMatchFromString:(NSString*)string usingRegex:(NSString *)regex;
- (NSString *)getMatchAtElement:(NSInteger)element fromString:(NSString*)string usingRegex:(NSString *)regex;
- (void)insertTrafficReports:(NSArray *)trafficReports;

@end
