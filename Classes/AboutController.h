#import <UIKit/UIKit.h>

@interface AboutController : UIViewController {
	IBOutlet UILabel *headingLabel;
	IBOutlet UILabel *copyrightLabel;
	IBOutlet UITextView *mainTextViewParagraph1;
	IBOutlet UITextView *mainTextViewParagraph2;
	IBOutlet UITextView *mainTextViewParagraph3;
}

@property (nonatomic, retain) IBOutlet UILabel *headingLabel;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;
@property (nonatomic, retain) IBOutlet UITextView *mainTextViewParagraph1;
@property (nonatomic, retain) IBOutlet UITextView *mainTextViewParagraph2;
@property (nonatomic, retain) IBOutlet UITextView *mainTextViewParagraph3;

- (IBAction)emailButtonClicked:(id)sender;

@end
