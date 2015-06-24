#import <UIKit/UIKit.h>

@interface CameraImageModalController : UIViewController {
	UIImage *image;
	IBOutlet UIImageView *cameraImageView;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *cameraImageView;

@end
