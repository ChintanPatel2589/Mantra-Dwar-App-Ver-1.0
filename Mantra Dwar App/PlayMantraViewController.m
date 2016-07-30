//
//  PlayMantraViewController.m
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/25/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "PlayMantraViewController.h"

@interface PlayMantraViewController ()

@end

@implementation PlayMantraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.txtViewMantraInfo.textAlignment = NSTextAlignmentJustified;
    [self.imgMantraImage.layer setBorderWidth:1];
    [self.imgMantraImage.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self setTextData];
    if (self.isFromNotification) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:194.0f/255.0f green:70.0f/255.0f blue:8.0f/255.0f alpha:1]];
        self.navigationController.navigationBar.translucent  = NO;
        self.navigationItem.hidesBackButton = YES;
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        UIFont *font = [UIFont fontWithName:@"Rockwell-bold" size:17.0f];
        
        NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
        [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
        [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName ];
        
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(popToBack)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
        [self playMantra:self];
    }
}
-(void)popToBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"MANTRADWAR";
}
-(void)setTextData
{
    self.lblMantraName.text = [self.selectedMantra valueForKey:@"mantra_name"];
    self.txtViewMantraInfo.text = [self.selectedMantra valueForKey:@"description"];
    if([[NSUserDefaults standardUserDefaults] valueForKey:[self.selectedMantra valueForKey:@"img_full_url"]])
    {
        self.imgMantraImage.image = [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] valueForKey:[self.selectedMantra objectForKey:@"img_full_url"]]];
    }
    else
    {
        [self.process startAnimating];
        [self downloadImage:[self.selectedMantra valueForKey:@"img_full_url"]];
    }
}
-(void)downloadImage:(NSString *)imageUrl
{
    NSURL *mapUrl = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:mapUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * r, NSData * d, NSError * e) {
        UIImage *img1 = [[UIImage alloc] initWithData:d];
        self.imgMantraImage.image=img1;
        img1 = nil;
        [[NSUserDefaults standardUserDefaults] setValue:d forKey:imageUrl];
        [self.process stopAnimating];
    }];
}
//-(void)updateSongTime
//{
//    self.lblSongRemainTimer.text = [NSString stringWithFormat:@"%.0f/%.0f",self.audioPlayer.duration - self.audioPlayer.currentTime,self.audioPlayer.duration];
//}
-(void)playSong:(NSNotification *)notiInfo
{
    NSURL *soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[self getMantraPath],[[notiInfo valueForKey:@"object"]valueForKey:@"songName"]] isDirectory:NO];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
}
#pragma mark downloading MP3 files
-(NSString *)getMantraPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyMantra"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return dataPath;
}
-(IBAction)playMantra:(id)sender
{
    if (!self.audioPlayer.isPlaying) {
        NSURL *soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[self getMantraPath],[NSString stringWithFormat:@"%@.mp3",[[self.selectedMantra valueForKey:@"mantra_name"]stringByReplacingOccurrencesOfString:@" " withString:@""]]] isDirectory:NO];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        self.audioPlayer.numberOfLoops = -1;
        [self.audioPlayer play];
        [self.btnPlay setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
//        NSLog(@"%f",(self.audioPlayer.duration/60));
//        self.songTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                          target:self
//                                                        selector:@selector(updateSongTime)
//                                                        userInfo:nil
//                                                         repeats:YES];

    }
    else
    {
        [self.audioPlayer stop];
        [self.btnPlay setImage:[UIImage imageNamed:@"Play-Icon.png"] forState:UIControlStateNormal];
//        if ([self.appOBJ.currentPlayingSong isEqualToString:[[self arrayData] objectAtIndex:indexPath.row]]) {
//
//        }
//        else
//        {
//            NSMutableDictionary *tmpDict = [ NSMutableDictionary dictionaryWithObject:[self.arrayData objectAtIndex:indexPath.row] forKey:@"songName"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"playSong" object:tmpDict];
//            tmpDict = nil;
//        }
    }
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
