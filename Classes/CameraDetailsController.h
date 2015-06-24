#import <UIKit/UIKit.h>
#import "Camera.h"
#import "UpdateCameraImageOperationDelegate.h"

@interface CameraDetailsController : UIViewController<UpdateCameraImageOperationDelegate> {
	Camera *camera;
	IBOutlet UILabel *nameLabel;
	IBOutlet UITextView *descriptionTextView;
	IBOutlet UIImageView *cameraImageView;
	UIImage *cameraImage;
	IBOutlet UIView *updatingView;
	IBOutlet UILabel *updatingLabel;
	IBOutlet UIActivityIndicatorView *updatingActivityIndicator;
}

@property (nonatomic, retain) Camera *camera;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UIImageView *cameraImageView;
@property (nonatomic, retain) UIImage *cameraImage;
@property (nonatomic, retain) IBOutlet UIView *updatingView;
@property (nonatomic, retain) IBOutlet UILabel *updatingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *updatingActivityIndicator;

- (void)addRefreshButton;
- (void)refreshButtonClicked:(id)sender;
- (void)refreshImage;
- (void)showUpdatingView;
- (void)hideUpdatingView;
- (void)displayCameraImageInModalView;

@end
