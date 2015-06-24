#import <UIKit/UIKit.h>
#import "Region.h"
#import "UpdateTrafficReportsOperationDelegate.h"


@interface TrafficReportsController : UIViewController<UITableViewDelegate,UITableViewDataSource,UpdateTrafficReportsOperationDelegate> {
	Region *region;
	NSDictionary *trafficReportsDictionary;
	IBOutlet UITableView *mainTableView;
	IBOutlet UILabel *lastUpdatedTimeLabel;
	IBOutlet UIView *headerView;
	IBOutlet UITextView *headerTextView;
	IBOutlet UIImageView *headerImageView;
	IBOutlet UIView *updatingView;
	IBOutlet UIActivityIndicatorView *updatingActivityIndicator;
	IBOutlet UILabel *updatingLabel;
}

@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSDictionary *trafficReportsDictionary;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UILabel *lastUpdatedTimeLabel;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITextView *headerTextView;
@property (nonatomic, retain) IBOutlet UIImageView *headerImageView;
@property (nonatomic, retain) IBOutlet UIView *updatingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *updatingActivityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *updatingLabel;

- (IBAction)refreshButtonClicked:(id)sender;
- (void)refreshTrafficReports;
- (void)setLastUpdatedTime;
- (void)addRefreshButton;
- (void)showUpdatingView;
- (void)showLastUpdatedLabel;

@end
