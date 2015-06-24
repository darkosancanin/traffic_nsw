#import "CamerasController.h"
#import "Camera.h"
#import "CameraDetailsController.h"

@implementation CamerasController

@synthesize region;
@synthesize cameras;
@synthesize mainTableView;
@synthesize headerView;
@synthesize headerTextView;
@synthesize headerImageView;

- (void)viewDidLoad{
	self.title = @"Cameras";
	self.cameras = [Camera getArrayOfCamerasByRegionId:self.region.regionId];
	mainTableView.tableHeaderView = headerView;
	headerTextView.text = self.region.name;
	headerTextView.font = [UIFont boldSystemFontOfSize:22];
	headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_large.png",self.region.regionId]];
	if(self.region.name.length < 18){
		CGRect frame = headerTextView.frame;
		frame.origin.y = frame.origin.y + 15;
		headerTextView.frame = frame;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cameras.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Camera *camera = [self.cameras objectAtIndex:indexPath.row];
	
	cell.font = [UIFont systemFontOfSize:13]; 
	[cell setText:camera.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	Camera *camera = [self.cameras objectAtIndex:indexPath.row];
	CameraDetailsController *cameraDetailsController = [[CameraDetailsController alloc] initWithNibName:@"CameraDetails" bundle:nil];
	cameraDetailsController.camera = camera;
	[self.navigationController pushViewController:cameraDetailsController animated:YES];
	[cameraDetailsController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)dealloc {
	[headerView release];
	[headerTextView release];
	[headerImageView release];
	[region release];
	[cameras release];
	[mainTableView release];
    [super dealloc];
}

@end
