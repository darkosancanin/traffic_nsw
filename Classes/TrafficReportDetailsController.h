#import <UIKit/UIKit.h>
#import "TrafficReport.h"

#define kLanesClosed 0
#define kLanesAffected 1
#define kStartedTime 2
#define kUpdatedTime 3
#define kFrom 4
#define kTo 5
#define kUBDReference 6
#define kImpact 7
#define kAttending 8
#define kRTAAdvice 9
#define kOtherAdvice 10

#define kTextFontSize 14

@interface TrafficReportDetailsController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	TrafficReport *trafficReport;
	IBOutlet UITableView *mainTableView;
	NSDictionary *tableSections;
}

@property (nonatomic, retain) TrafficReport *trafficReport;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSDictionary *tableSections;

- (void)setTableSections;
- (NSString *)getTextForSection:(NSInteger)section;
- (void)setTitle;

@end
