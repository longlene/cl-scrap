// 陀螺仪是否可用
//
#import <CoreMotion/CoreMotion.h>

- (BOOL)isGyroscopeAvailable
{
        CMMotionManager *motionManager = [[CMMotionManger alloc] init];
        BOOL gyroscopeAvailable = motionManager.gyroAvailable;
        [motionManager release];
        return gyroscopeAvailable;
}
