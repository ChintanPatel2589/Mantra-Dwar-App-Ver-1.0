//
//  ViewController.m
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/18/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAlbumListViewController.h"
#import "PlayMantraViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"MANTRADWAR";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:194.0f/255.0f green:70.0f/255.0f blue:8.0f/255.0f alpha:1]];
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationItem.hidesBackButton = YES;

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    UIFont *font = [UIFont fontWithName:@"Rockwell-bold" size:17.0f];
    
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName ];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    self.arrayData = [[NSMutableArray alloc]init];
    [self setTabBar];
    [self addRightBarDownloadBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"MANTRADWAR";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isNotificationON"]) {
         [self.switchMantra setOn:YES animated:NO];
    }
    else
    {
         [self.switchMantra setOn:NO animated:NO];
    }
    [self getAllFiles];
    [self.tblView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.arrayData.count > 0) {
        return self.arrayData.count;
    }
    else
        return 1;    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UIImageView *imgPlay,*imgCellBack,*imgCellLine;//,*imgCellSelectBtn;
    UILabel *lblMantraName;
    UIButton *btnRadio;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
        imgCellBack = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, cell.frame.size.width-10, cell.frame.size.height)];
        imgCellBack.image = [UIImage imageNamed:@"mantra_list.png"];
       imgCellBack.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );
        imgCellBack.tag = 1012;
        [cell addSubview:imgCellBack];
        
        imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
        imgPlay.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin );
        imgPlay.image = [UIImage imageNamed:@"large_pic.png"];
        imgPlay.tag = 1013;
        [cell addSubview:imgPlay];
        
        lblMantraName = [[UILabel alloc]initWithFrame:CGRectMake(45, 7, 220, 25)];
        lblMantraName.backgroundColor = [UIColor clearColor];
        lblMantraName.textColor = [UIColor colorWithRed:194.0f/255.0f green:70.0f/255.0f blue:8.0f/255.0f alpha:1];
        lblMantraName.numberOfLines = 0;
        lblMantraName.tag = 1014;
        lblMantraName.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
        [cell addSubview:lblMantraName];
        
        imgCellLine = [[UIImageView alloc]initWithFrame:CGRectMake(273, 5, 5, cell.frame.size.height-10)];
        imgCellLine.image = [UIImage imageNamed:@"sap_line.png"];
        imgCellLine.tag = 1015;
        imgCellLine.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin );
        [cell addSubview:imgCellLine];
        
        btnRadio = [[UIButton alloc]initWithFrame:CGRectMake(282, 8, 27, 27)];
        [btnRadio setImage:[UIImage imageNamed:@"radio_btn_off.png"] forState:UIControlStateNormal];
        btnRadio.tag = 1016;
        btnRadio.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin );
        [btnRadio addTarget:self action:@selector(radioBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnRadio];

    }
    else
    {
        imgCellBack = (UIImageView *)[cell viewWithTag:1012];
        imgPlay = (UIImageView *)[cell viewWithTag:1013];
        lblMantraName = (UILabel *)[cell viewWithTag:1014];
        imgCellLine = (UIImageView *)[cell viewWithTag:1015];
        btnRadio = (UIButton *)[cell viewWithTag:1016];
       
    }
    if([[self arrayData] count]>0)
    {
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedMantra"]) {
            if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedMantra"] valueForKey:@"mantra_name"] isEqualToString:[[self.arrayData objectAtIndex:indexPath.row] valueForKey:@"mantra_name"]]) {
                [btnRadio setImage:[UIImage imageNamed:@"radio_btn_on.png"] forState:UIControlStateNormal];
            }
            else
            {
                [btnRadio setImage:[UIImage imageNamed:@"radio_btn_off.png"] forState:UIControlStateNormal];
            }
        }
        lblMantraName.text = [[[self arrayData] objectAtIndex:indexPath.row] valueForKey:@"mantra_name"];
        btnRadio.hidden = false;
        imgCellLine.hidden = false;
    }
    else
    {
        lblMantraName.text = @"No Mantra Exist";
        btnRadio.hidden = true;
        imgCellLine.hidden = true;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayData.count>0) {
        PlayMantraViewController *playOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayMantraViewController"];
        playOBJ.selectedMantra = [[self arrayData] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:playOBJ animated:YES];
    }
   
}
-(void)radioBtnTapped:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.tblView indexPathForCell:cell];
    [[NSUserDefaults standardUserDefaults] setObject:[self.arrayData objectAtIndex:indexPath.row] forKey:@"selectedMantra"];
    
     //[[NSUserDefaults standardUserDefaults] setValue:[[self.arrayData objectAtIndex:indexPath.row] valueForKey:@"mantra_name"] forKey:@"selectedMantra"];
    [self.tblView reloadData];
    indexPath = nil;
    cell = nil;
}
#pragma mark Action
#pragma mark Switch Methods
-(IBAction)switchOnOff:(UISwitch *)sender
{
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"isNotificationON"];
        [self scheduleNotification];
    } else{
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isNotificationON"];
         [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}
#pragma mark Activate Notification
- (void)scheduleNotification {
    UILocalNotification *reminderNote = [[UILocalNotification alloc]init];
    reminderNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
//    reminderNote.repeatInterval = NSCalendarUnitDay;
    reminderNote.repeatInterval = NSCalendarUnitHour;
    reminderNote.alertBody = @"It's time to play Mantra";
    reminderNote.alertAction = @"View";
    reminderNote.soundName =UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:reminderNote];
    reminderNote = nil;
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
-(void)downloadMatra
{
    DownloadMantraViewController *downOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadMantraViewController"];
    [self.navigationController pushViewController:downOBJ animated:YES];
}
-(void)getAllFiles
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadedMantra"]) {
        self.arrayData = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadedMantra"]];
    }
    //self.arrayData =[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[self getMantraPath] error:nil];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF EndsWith '.mp3'"];
    //self.arrayData =  [self.arrayData filteredArrayUsingPredicate:predicate];
    
}

#pragma mark Set TabBar Appearence
-(void)setTabBar
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor grayColor] }forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];

    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

        [[UITabBar appearance] setShadowImage:nil];
    
    //Selecete Image 
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"Selected.png"]];
}
#pragma mark - Tab bar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//     NSLog(@"click:%d Tag : %d",[[tabBar items] indexOfObject:item],item.tag);
    if (item.tag == 2) {
        PhotoAlbumListViewController *photoOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoAlbumListViewController"];
        [self.navigationController pushViewController:photoOBJ animated:NO];
    }
    //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tabBarClicked" object:nil]];
}
#pragma mark Download Btn
-(void)addRightBarDownloadBtn
{
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(10, 2, 37, 37)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:@"downloaIcon.png"] forState:UIControlStateNormal];
    
    leftButton.tintColor = [UIColor whiteColor]; //Your desired color.
    leftButton.autoresizesSubviews = YES;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(downloadMatra) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
- (void)scheduleNotification:(NSDate *)date {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = date;
    
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = @"Body";
    notif.alertAction = @"AlertButtonCaption";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    notif = nil;
}
#pragma mark Alert Methods
-(void)alert:(NSString *)title msg :(NSString *)msg alertTag:(int)tag cancelTitile:(NSString *)cancelTitle okTitle:(NSString *)okTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alert.delegate = self;
    alert.tag = tag;
    [alert show];
    alert = nil;
}
@end
