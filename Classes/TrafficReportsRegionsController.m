#import "TrafficReportsRegionsController.h"
#import "NSWTrafficAppDelegate.h"
#import "Region.h"
#import "TrafficReportsController.h"
#import "AboutController.h"

@implementation TrafficReportsRegionsController

@synthesize regionsDictionary;

- (void)viewDidLoad{
	self.regionsDictionary = [Region getDictionaryOfRegions];
	[self addInfoButton];
}

- (void)addInfoButton{
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.rightBarButtonItem = infoButtonItem;	
}

- (void)infoButtonClicked{
	AboutController *aboutController = [[AboutController alloc] initWithNibName:@"About" bundle:nil];
	[self.navigationController pushViewController:aboutController animated:YES];
	[aboutController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
		return [[self.regionsDictionary objectForKey:kAreaNameSydney] count];
	}
	else{
		return [[self.regionsDictionary objectForKey:kAreaNameRegional] count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0){
		return kAreaNameSydney;
	}
	else{
		return kAreaNameRegional;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString *key = (indexPath.section == 0) ? kAreaNameSydney : kAreaNameRegional;
	Region *region = [[self.regionsDictionary objectForKey:key] objectAtIndex:indexPath.row];
	[cell setText:region.name];
	cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_small.png",region.regionId]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	TrafficReportsController *trafficReportsController = [[TrafficReportsController alloc] initWithNibName:@"TrafficReports" bundle:nil];
	NSString *key = (indexPath.section == 0) ? kAreaNameSydney : kAreaNameRegional;
	Region *region = [[self.regionsDictionary objectForKey:key] objectAtIndex:indexPath.row];
	trafficReportsController.region = region;
	[self.navigationController pushViewController:trafficReportsController animated:YES];
	[trafficReportsController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
	[regionsDictionary release];
    [super dealloc];
}

@end

