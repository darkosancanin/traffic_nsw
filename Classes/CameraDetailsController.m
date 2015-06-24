#import "CameraDetailsController.h"
#import "Camera.h"
#import "NSWTrafficAppDelegate.h"
#import "UpdateCameraImageOperation.h"
#import "CameraImageModalController.h"

@implementation CameraDetailsController

@synthesize camera;
@synthesize nameLabel;
@synthesize descriptionTextView;
@synthesize cameraImageView;
@synthesize cameraImage;
@synthesize updatingView;
@synthesize updatingLabel;
@synthesize updatingActivityIndicator;

- (void)viewDidLoad{
	self.title = @"Camera";
	self.nameLabel.font = [UIFont boldSystemFontOfSize:22];
	self.nameLabel.text = self.camera.name;
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.descriptionTextView.font = [UIFont systemFontOfSize:12];
	self.descriptionTextView.text = self.camera.description;
	[self addRefreshButton];
	[self refreshImage];
}

- (void)addRefreshButton{
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked:)];
	self.navigationItem.rightBarButtonItem = refresh;	
}

- (void)updateCameraImageOperationDidFinishWithImage:(UIImage *)image{
	[self hideUpdatingView];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.cameraImage = image;
	UIGraphicsBeginImageContext( CGSizeMake(290, 236) );
	[image drawInRect:CGRectMake( 0, 0, 290, 236)];
	UIImage *sizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.cameraImageView.image = sizedImage;
}

- (void)refreshButtonClicked:(id)sender{
	[self refreshImage];
}

- (void)refreshImage{
	[self showUpdatingView];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	UpdateCameraImageOperation *updateCameraImageOperation = [[UpdateCameraImageOperation alloc] initWithCamera:self.camera];
	updateCameraImageOperation.delegate = self;
	NSWTrafficAppDelegate *appDelegate = (NSWTrafficAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.operationQueue addOperation:updateCameraImageOperation];
	[updateCameraImageOperation release];
}

- (void)showUpdatingView{
	self.updatingView.hidden = NO;
	[self.updatingActivityIndicator startAnimating];
	self.updatingLabel.font = [UIFont systemFontOfSize:11];
}

- (void)hideUpdatingView{
	self.updatingView.hidden = YES;
	[self.updatingActivityIndicator stopAnimating];
}

- (void)updateCameraImageOperationDidFailWithReason:(NSString *)reason{
	[self hideUpdatingView];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	NSString *message = @"There was an error while retrieving the camera image. Please try again.";
	if(reason != nil){
		message = [NSString stringWithFormat:@"%@\nReason: %@", message, reason];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)updateCameraImageOperationConnectionDidFailWithReason:(NSString *)reason{
	[self hideUpdatingView];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	NSString *message = @"Unable to retrieve the camera image. Please ensure you have an active internet connection, then click on the refresh button.";
	if(reason != nil){
		message = [NSString stringWithFormat:@"%@\nReason: %@", message, reason];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)displayCameraImageInModalView{
	if(self.cameraImage != nil){
		CameraImageModalController *cameraImageModalController = [[CameraImageModalController alloc] initWithNibName:@"CameraImageModal" bundle:nil];
		cameraImageModalController.image = self.cameraImage;
		[self presentModalViewController:cameraImageModalController animated:NO];
		[cameraImageModalController release];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint locationInView = [touch locationInView:self.cameraImageView];
	if (locationInView.x >= 0 && locationInView.x <= cameraImageView.frame.size.width) {
		if (locationInView.y >= 0 && locationInView.y <= cameraImageView.frame.size.height) {
			[self displayCameraImageInModalView];
		}
	}
}

- (void)dealloc {
	[updatingView release];
	[updatingLabel release];
	[updatingActivityIndicator release];
	[cameraImage release];
	[nameLabel release];
	[descriptionTextView release];
	[cameraImageView release];
	[camera release];
    [super dealloc];
}

@end
