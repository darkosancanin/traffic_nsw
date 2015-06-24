#import <Foundation/Foundation.h>
#import "Camera.h"
#import "UpdateCameraImageOperationDelegate.h"

@interface UpdateCameraImageOperation : NSOperation {
	Camera *camera;
	NSObject<UpdateCameraImageOperationDelegate> *delegate;
}

@property (nonatomic, retain) Camera *camera;
@property (nonatomic, retain) NSObject<UpdateCameraImageOperationDelegate> *delegate;

- (id)initWithCamera:(Camera *)cameraToUpdate;
- (UIImage *)getImageForCamera;

@end
