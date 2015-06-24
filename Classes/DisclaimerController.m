#import "DisclaimerController.h"

@implementation DisclaimerController

@synthesize acceptButton;
@synthesize declineButton;
@synthesize headingLabel;
@synthesize mainTextView;

- (void)viewDidLoad{
	headingLabel.font = [UIFont boldSystemFontOfSize:22];
	self.mainTextView.font = [UIFont systemFontOfSize:14];
	acceptButton.segmentedControlStyle = UISegmentedControlStyleBar;
	acceptButton.tintColor = [UIColor greenColor];
	declineButton.segmentedControlStyle = UISegmentedControlStyleBar;
	declineButton.tintColor = [UIColor redColor];
}

- (IBAction)acceptButtonClicked:(id)sender{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:@"UserHasAcceptedDisclaimer"];
	[self dismissModalViewControllerAnimated:NO];
}

- (IBAction)declineButtonClicked:(id)sender{
	NSString *message = @"You must read and accept the disclaimer before using the application. If you would like to exit the application, please click on the home button.";
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)dealloc {
	[mainTextView release];
	[headingLabel release];
	[acceptButton release];
	[declineButton release];
    [super dealloc];
}

@end
