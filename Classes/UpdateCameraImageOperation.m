#import "UpdateCameraImageOperation.h"

@implementation UpdateCameraImageOperation

@synthesize camera;
@synthesize delegate;

- (id)initWithCamera:(Camera *)cameraToUpdate;
{
    if (![super init]) return nil;
    self.camera = cameraToUpdate;
    return self;
}

- (void)main {
	@try {
		UIImage *image = [self getImageForCamera];
		[delegate performSelectorOnMainThread:@selector(updateCameraImageOperationDidFinishWithImage:) withObject:image waitUntilDone:NO];
	}
	@catch (NSException *e) {
		[delegate performSelectorOnMainThread:@selector(updateCameraImageOperationDidFailWithReason:) withObject:[e reason] waitUntilDone:NO];
	}
}

- (UIImage *)getImageForCamera{
	NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:self.camera.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
	NSError *error;
	NSURLResponse *response;
	NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	if(error != nil){
		[delegate performSelectorOnMainThread:@selector(updateCameraImageOperationConnectionDidFailWithReason:) withObject:[error localizedDescription] waitUntilDone:NO];
		return nil;
	}
	
	if(imageData == nil){
		[delegate performSelectorOnMainThread:@selector(updateCameraImageOperationConnectionDidFailWithReason:) withObject:nil waitUntilDone:NO];
		return nil;
	}

	UIImage *image = [[UIImage alloc] initWithData:imageData];
	return image;
}

- (void)dealloc{
	[delegate release];
	[camera release];
	[super dealloc];
}

@end
