// 使用摄像头
- (IBAction)loadPhotoPicker:(id)sender
{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        // for front camera
        // imagePicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
}
