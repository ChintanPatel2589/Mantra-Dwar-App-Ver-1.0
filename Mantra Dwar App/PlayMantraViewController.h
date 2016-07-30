//
//  PlayMantraViewController.h
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/25/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayMantraViewController : UIViewController
@property(nonatomic,retain)NSDictionary *selectedMantra;
@property(nonatomic,retain)IBOutlet UIButton *btnPlay;
@property(nonatomic,retain) IBOutlet UILabel *lblMantraName;
@property(nonatomic,retain) IBOutlet UIImageView *imgMantraImage;
@property(nonatomic,retain) IBOutlet UITextView *txtViewMantraInfo;
@property(nonatomic,retain)AVAudioPlayer *audioPlayer;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *process;
@property(nonatomic)BOOL isFromNotification;
//@property(nonatomic,retain)NSTimer *songTimer;
//@property(nonatomic,retain)IBOutlet UILabel *lblSongRemainTimer;
@end
