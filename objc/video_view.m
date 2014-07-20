
UIView *cameraView;


[CCDirector sharedDirector].openGLView.backgroundColor = [UIColor clearColor];
[CCDirector sharedDirector].openGLView.opaque = NO;

glClearColor(0.0, 0.0, 0.0, 0.0);

cameraView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
cameraView.opaque = NO;
cameraView.backgroundColor = [UIColor clearColor];
[window addSubview:cameraView];

