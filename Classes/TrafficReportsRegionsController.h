#import <UIKit/UIKit.h>

@interface TrafficReportsRegionsController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	NSDictionary *regionsDictionary;
}

@property (nonatomic, retain) NSDictionary *regionsDictionary;

- (void)addInfoButton;
- (void)infoButtonClicked;

@end
