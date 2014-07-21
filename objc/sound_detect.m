
#include <AVFoundation/AVFoundation.h>

AVAudioSession *audioSession = [AVAudioSession sharedInstance];

BooOOL audioAvailable = audioSession.inputIsAvailable;

