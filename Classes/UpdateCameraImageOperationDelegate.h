#import <Foundation/Foundation.h>

@protocol UpdateCameraImageOperationDelegate <NSObject>

@required
- (void)updateCameraImageOperationDidFinishWithImage:(UIImage *)image;
- (void)updateCameraImageOperationDidFailWithReason:(NSString *)reason;
- (void)updateCameraImageOperationConnectionDidFailWithReason:(NSString *)reason;

@end
