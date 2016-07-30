//
//  PhotoAlbumListViewController.m
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/26/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "PhotoAlbumListViewController.h"
#import "ViewController.h"

#import "GalleryViewController.h"
@interface PhotoAlbumListViewController ()

@end

@implementation PhotoAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"AlbumList"]) {
        self.arrayData = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"AlbumList"]];
    }
    else
    {
        [self.process startAnimating];
    }
    //[self addRightBarDownloadBtn];
    [self setTabBar];
    [self getAlbumListFromServer];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"PHOTO ALBUM";
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
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
-(void)downloadMatra
{
    DownloadMantraViewController *downOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadMantraViewController"];
    [self.navigationController pushViewController:downOBJ animated:YES];
}
#pragma mark Set TabBar Appearence
-(void)setTabBar
{
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor grayColor] }forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setShadowImage:nil];
    
    //Selecete Image
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"Selected.png"]];
}
#pragma mark - Tab bar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        ViewController *photoOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:photoOBJ animated:NO];
    }
}
#pragma mark get Mantra List From Remote Server
-(void)getAlbumListFromServer
{
    @try {
        if ([self connected])
        {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",urlAlbumList] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            // NSLog(@"%@", request.URL);
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err){
                if (err) {
                    NSLog(@"album list gettting fail:%@",err);
                    return;
                }
                else
                {
                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                    self.arrayData =[[NSMutableArray alloc]initWithArray:[parsedObject valueForKey:@"album_data"]];
                    [self.tblView reloadData];
                    [self.process stopAnimating];
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AlbumList"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.arrayData forKey:@"AlbumList"];
                    parsedObject = nil;
                }
            }];
        }
        else
        {
            [self.process stopAnimating];
            [self alert:@"No Interner Connection" msg:@"Please Check You Internet Connection." alertTag:0 cancelTitile:nil okTitle:@"Ok"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error:%@",exception);
    }
    @finally {
        
    }
}
#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayData count];    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UIImageView *imgPlay,*imgCellBack;
    UILabel *lblMantraName;
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
        imgPlay.image = [UIImage imageNamed:@"large_pic.png"];
        imgPlay.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin );
        imgPlay.tag = 1013;
        [cell addSubview:imgPlay];
        
        lblMantraName = [[UILabel alloc]initWithFrame:CGRectMake(45, 7, 220, 25)];
        lblMantraName.backgroundColor = [UIColor clearColor];
        lblMantraName.textColor = [UIColor colorWithRed:194.0f/255.0f green:70.0f/255.0f blue:8.0f/255.0f alpha:1];
        lblMantraName.numberOfLines = 0;
         lblMantraName.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
        lblMantraName.tag = 1014;
        [cell addSubview:lblMantraName];
        
    }
    else
    {
        imgCellBack = (UIImageView *)[cell viewWithTag:1012];
        imgPlay = (UIImageView *)[cell viewWithTag:1013];
        lblMantraName = (UILabel *)[cell viewWithTag:1014];
    }
    if([[self arrayData] count]>0)
    {
        lblMantraName.text = [[self.arrayData objectAtIndex:indexPath.row]valueForKey:@"album_name"];
        //separatorLineView = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryViewController *photoGalleryOBJ = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:nil];
    photoGalleryOBJ.albumID = [[self.arrayData objectAtIndex:indexPath.row] valueForKey:@"album_id"];
    [self.navigationController pushViewController:photoGalleryOBJ animated:YES];
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
