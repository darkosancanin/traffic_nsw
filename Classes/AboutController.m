#import "AboutController.h"

@implementation AboutController

@synthesize headingLabel;
@synthesize copyrightLabel;
@synthesize mainTextViewParagraph1;
@synthesize mainTextViewParagraph2;
@synthesize mainTextViewParagraph3;

- (void)viewDidLoad{
	self.title = @"About";
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.headingLabel.font = [UIFont boldSystemFontOfSize:24];
	self.copyrightLabel.font = [UIFont systemFontOfSize:14];
	self.mainTextViewParagraph1.font = [UIFont systemFontOfSize:15];
	self.mainTextViewParagraph2.font = [UIFont systemFontOfSize:15];
	self.mainTextViewParagraph3.font = [UIFont systemFontOfSize:15];
}

- (IBAction)emailButtonClicked:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://darko@idarko.com"]];
}

- (void)dealloc {
	[headingLabel release];
	[copyrightLabel release];
	[mainTextViewParagraph1 release];
	[mainTextViewParagraph2 release];
	[mainTextViewParagraph3 release];
    [super dealloc];
}


@end
