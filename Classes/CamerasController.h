#import <UIKit/UIKit.h>
#import "Camera.h"
#import "Region.h"

@interface CamerasController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	Region *region;
	NSArray *cameras;
	IBOutlet UITableView *mainTableView;
	IBOutlet UIView *headerView;
	IBOutlet UITextView *headerTextView;
	IBOutlet UIImageView *headerImageView;
}

@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSArray *cameras;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITextView *headerTextView;
@property (nonatomic, retain) IBOutlet UIImageView *headerImageView;

@end
