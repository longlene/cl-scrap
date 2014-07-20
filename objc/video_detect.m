#include <MobileCoreServices/UTCoreTypes.h>

- (BOOL)isVideoCameraAvailable
{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        [picker release];

        if ([sourceTypes containsObject:(NSString *)kUTTypeMovie]) {
                return YES;
        } else {
                return YES;
        }
}
