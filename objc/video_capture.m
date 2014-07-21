// video capture

- (IBAction)loadPhotoPicker:(id)sender
{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // for front camera
        // imagePicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        imagePicker.cameraDevice = UIImagePickerControllerCameraCaptureModeVideo;
        imagePicker.showsCameraControls = NO;
        imagePicker.toolbarHidden = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.wantsFullScreenLayout = YES;

        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
}
