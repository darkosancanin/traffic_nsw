#import "CameraImageModalController.h"

@implementation CameraImageModalController

@synthesize image;
@synthesize cameraImageView;

- (void)viewDidLoad{
	self.cameraImageView.image = self.image;
	CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
	[self.cameraImageView setTransform:rotate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 1) {
		[self dismissModalViewControllerAnimated:NO];
	}
}

- (void)dealloc {
	[cameraImageView release];
	[image release];
    [super dealloc];
}


@end
