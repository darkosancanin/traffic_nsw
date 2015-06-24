#import <Foundation/Foundation.h>

@interface Camera : NSObject {
	NSInteger cameraId;
	NSInteger regionId;
	NSString *name;
	NSString *description;
	NSString *url;
}

@property (nonatomic) NSInteger cameraId;
@property (nonatomic) NSInteger regionId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *url;

+ (NSArray *)getArrayOfCamerasByRegionId:(NSInteger)regionId;

@end
