#import <UIKit/UIKit.h>

@interface CamerasRegionsController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	NSDictionary *regionsDictionary;
}

@property (nonatomic, retain) NSDictionary *regionsDictionary;

- (void)addInfoButton;

@end
