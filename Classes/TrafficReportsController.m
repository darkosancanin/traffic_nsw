#import "TrafficReportsController.h"
#import "TrafficReport.h"
#import "Region.h"
#import "NSWTrafficAppDelegate.h"
#import "UpdateTrafficReportsOperation.h"
#import "TrafficReportDetailsController.h"

@implementation TrafficReportsController

@synthesize region;
@synthesize trafficReportsDictionary;
@synthesize mainTableView;
@synthesize lastUpdatedTimeLabel;
@synthesize headerView;
@synthesize headerTextView;
@synthesize headerImageView;
@synthesize updatingView;
@synthesize updatingActivityIndicator;
@synthesize updatingLabel;

- (void)viewDidLoad{
	self.title = @"Traffic Reports";
	self.trafficReportsDictionary = [TrafficReport getDictionaryOfTrafficReportsByRegionId:self.region.regionId];
	[self setLastUpdatedTime];
	mainTableView.tableHeaderView = headerView;
	headerTextView.text = self.region.name;
	headerTextView.font = [UIFont boldSystemFontOfSize:22];
	headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_large.png",self.region.regionId]];
	if(self.region.name.length < 18){
		CGRect frame = headerTextView.frame;
		frame.origin.y = frame.origin.y + 15;
		headerTextView.frame = frame;
	}
	[self addRefreshButton];
	[self refreshTrafficReports];
}

- (void)addRefreshButton{
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked:)];
	self.navigationItem.rightBarButtonItem = refresh;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.trafficReportsDictionary objectForKey:[NSNumber numberWithInteger:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	switch (section) {
		case kTrafficReportTypeCurrentConditions:
			return @"Current Conditions"; break;
		case kTrafficReportTypeRoadWorks:
			return @"Road Works"; break;
		case kTrafficReportTypeSpecialEvents:
			return @"Special Events"; break;
		default:
			return @""; break;
	};
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	NSInteger incidentCount = [[self.trafficReportsDictionary objectForKey:[NSNumber numberWithInteger:section]] count];
	return (incidentCount == 0) ? @"No incidents reported" : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	TrafficReport *trafficReport = [[self.trafficReportsDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectAtIndex:indexPath.row];
	
	cell.font = [UIFont systemFontOfSize:13]; 
	[cell setText:trafficReport.description];
    return cell;
}

- (IBAction)refreshButtonClicked:(id)sender{
	[self refreshTrafficReports];
}

- (void)refreshTrafficReports{
	[self showUpdatingView];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	UpdateTrafficReportsOperation *updateTrafficReportsOperation = [[UpdateTrafficReportsOperation alloc] initWithRegion:self.region];
	updateTrafficReportsOperation.delegate = self;
	NSWTrafficAppDelegate *appDelegate = (NSWTrafficAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.operationQueue addOperation:updateTrafficReportsOperation];
	[updateTrafficReportsOperation release];
}

- (void)trafficReportsDidUpdateAt:(NSDate *)dateTimeUpdated{
	self.region.lastUpdated = dateTimeUpdated;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.trafficReportsDictionary = [TrafficReport getDictionaryOfTrafficReportsByRegionId:self.region.regionId];
	[mainTableView reloadData];
	[self setLastUpdatedTime];
}

- (void)trafficReportsUpdateOperationDidFailWithReason:(NSString *)reason{
	[self showLastUpdatedLabel];
	NSString *message = @"There was an error while updating the traffic reports. Please try again.";
	if(reason != nil){
		message = [NSString stringWithFormat:@"%@\nReason: %@", message, reason];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)trafficReportsUpdateOperationConnectionDidFailWithReason:(NSString *)reason{
	[self showLastUpdatedLabel];
	NSString *message = @"Unable to retrieve data. Please ensure you have an active internet connection, then click on the refresh button.";
	if(reason != nil){
		message = [NSString stringWithFormat:@"%@\nReason: %@", message, reason];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)setLastUpdatedTime{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
	[dateFormatter setDateFormat:@"dd/MM/yy h:mm a"]; 
	NSString *dateTimeAsString = [dateFormatter stringFromDate:self.region.lastUpdated]; 
	[self.lastUpdatedTimeLabel setText:[NSString stringWithFormat:@"Last Updated %@",dateTimeAsString]];
	self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
	[dateFormatter release];
	[self showLastUpdatedLabel];
}

- (void)showUpdatingView{
	self.updatingLabel.font = [UIFont systemFontOfSize:11];
	self.updatingView.hidden = NO;
	self.lastUpdatedTimeLabel.hidden = YES;
	[self.updatingActivityIndicator startAnimating];
}

- (void)showLastUpdatedLabel{
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.updatingView.hidden = YES;
	self.lastUpdatedTimeLabel.hidden = NO;
	[self.updatingActivityIndicator stopAnimating];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	TrafficReportDetailsController *trafficReportDetailsController = [[TrafficReportDetailsController alloc] initWithNibName:@"TrafficReportDetails" bundle:nil];
	TrafficReport *trafficReport = [[self.trafficReportsDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectAtIndex:indexPath.row];
	trafficReportDetailsController.trafficReport = trafficReport;
	[self.navigationController pushViewController:trafficReportDetailsController animated:YES];
	[trafficReportDetailsController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)dealloc {
	[updatingView release];
	[updatingActivityIndicator release];
	[updatingLabel release];
	[headerView release];
	[headerTextView release];
	[headerImageView release];
	[lastUpdatedTimeLabel release];
	[region release];
	[trafficReportsDictionary release];
	[mainTableView release];
    [super dealloc];
}

@end
