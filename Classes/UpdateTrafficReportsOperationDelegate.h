#import <Foundation/Foundation.h>

@protocol UpdateTrafficReportsOperationDelegate <NSObject>

@required
- (void)trafficReportsDidUpdateAt:(NSDate *)dateTimeUpdated;
- (void)trafficReportsUpdateOperationDidFailWithReason:(NSString *)reason;
- (void)trafficReportsUpdateOperationConnectionDidFailWithReason:(NSString *)reason;

@end
