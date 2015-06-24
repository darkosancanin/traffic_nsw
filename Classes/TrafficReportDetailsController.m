#import "TrafficReportDetailsController.h"
#import "TrafficReport.h"
#import "StringHelper.h"

@implementation TrafficReportDetailsController

@synthesize trafficReport;
@synthesize mainTableView;
@synthesize tableSections;

- (void)viewDidLoad{
	[self setTableSections];
	[self setTitle];
}

- (void)setTitle{
	self.title = @"Details";
	NSString *title = [NSString stringWithFormat:@"%@\n%@",self.trafficReport.description, self.trafficReport.descriptionDetails];
	UILabel *headerLabel = [title labelWithBoldSystemFontOfSize:20];
	headerLabel.text = title;
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerLabel.frame.size.width + headerLabel.frame.origin.x, headerLabel.frame.size.height + headerLabel.frame.origin.y)];
	[headerView addSubview:headerLabel];
	self.mainTableView.tableHeaderView = headerView;
}

- (void)setTableSections{
	NSMutableDictionary *sections = [[NSMutableDictionary alloc] init];
	
	NSInteger sectionIndex = 0;
	
	if(self.trafficReport.lanesClosed.length > 0) { [sections setObject:[NSNumber numberWithInteger:kLanesClosed] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.lanesAffected.length > 0) { [sections setObject:[NSNumber numberWithInteger:kLanesAffected] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.startedTime.length > 0) { [sections setObject:[NSNumber numberWithInteger:kStartedTime] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.updatedTime.length > 0) { [sections setObject:[NSNumber numberWithInteger:kUpdatedTime] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.from.length > 0) { [sections setObject:[NSNumber numberWithInteger:kFrom] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.to.length > 0) { [sections setObject:[NSNumber numberWithInteger:kTo] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.ubdReference.length > 0) { [sections setObject:[NSNumber numberWithInteger:kUBDReference] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.impact.length > 0) { [sections setObject:[NSNumber numberWithInteger:kImpact] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.attending.length > 0) { [sections setObject:[NSNumber numberWithInteger:kAttending] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.rtaAdvice.length > 0) { [sections setObject:[NSNumber numberWithInteger:kRTAAdvice] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	if(self.trafficReport.otherAdvice.length > 0) { [sections setObject:[NSNumber numberWithInteger:kOtherAdvice] forKey:[NSNumber numberWithInteger:sectionIndex++]]; }
	
	self.tableSections = sections;
	[sections release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.tableSections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSInteger tableSection = [[self.tableSections objectForKey:[NSNumber numberWithInteger:section]] intValue];
	switch (tableSection) {
		case kLanesClosed:
			return @"Lanes Closed"; break;
		case kLanesAffected:
			return @"Lanes Affected"; break;
		case kStartedTime:
			return @"Started Time"; break;
		case kUpdatedTime:
			return @"Updated Time"; break;
		case kFrom:
			return @"From"; break;
		case kTo:
			return @"To"; break;
		case kUBDReference:
			return @"UBD Reference"; break;
		case kImpact:
			return @"Impact"; break;
		case kAttending:
			return @"Attending"; break;
		case kRTAAdvice:
			return @"RTA Advice"; break;
		case kOtherAdvice:
			return @"Other Advice"; break;
		default:
			break;
	}
	return nil;
}

- (NSString *)getTextForSection:(NSInteger)section{
	NSInteger tableSection = [[self.tableSections objectForKey:[NSNumber numberWithInteger:section]] intValue];
	switch (tableSection) {
		case kLanesClosed:
			return self.trafficReport.lanesClosed; break;
		case kLanesAffected:
			return self.trafficReport.lanesAffected; break;
		case kStartedTime:
			return self.trafficReport.startedTime; break;
		case kUpdatedTime:
			return self.trafficReport.updatedTime; break;
		case kFrom:
			return self.trafficReport.from; break;
		case kTo:
			return self.trafficReport.to; break;
		case kUBDReference:
			return self.trafficReport.ubdReference; break;
		case kImpact:
			return self.trafficReport.impact; break;
		case kAttending:
			return self.trafficReport.attending; break;
		case kRTAAdvice:
			return self.trafficReport.rtaAdvice; break;
		case kOtherAdvice:
			return self.trafficReport.otherAdvice; break;
		default:
			break;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    if ([[cell.contentView subviews] count] > 0) {
		UIView *labelToClear = [[cell.contentView subviews] objectAtIndex:0];
		[labelToClear removeFromSuperview];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSString *text = [self getTextForSection:indexPath.section];
	UILabel *cellLabel = [text labelWithSystemFontOfSize:kTextFontSize];
	[cell.contentView addSubview:cellLabel];
	[cellLabel release];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *text = [self getTextForSection:indexPath.section];
	CGFloat height = [text textHeightForSystemFontOfSize:kTextFontSize] + 20.0;
	return height;
} 

- (void)dealloc {
	[tableSections release];
	[mainTableView release];
	[trafficReport release];
    [super dealloc];
}


@end
