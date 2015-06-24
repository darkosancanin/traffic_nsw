#import <UIKit/UIKit.h>

@interface DisclaimerController : UIViewController {
	IBOutlet UISegmentedControl *acceptButton;
	IBOutlet UISegmentedControl *declineButton;
	IBOutlet UILabel *headingLabel;
	IBOutlet UITextView *mainTextView;
}

@property (nonatomic, retain) UISegmentedControl *acceptButton;
@property (nonatomic, retain) UISegmentedControl *declineButton;
@property (nonatomic, retain) UILabel *headingLabel;
@property (nonatomic, retain) UITextView *mainTextView;

- (IBAction)acceptButtonClicked:(id)sender;
- (IBAction)declineButtonClicked:(id)sender;

@end
