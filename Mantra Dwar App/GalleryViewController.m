//
//  GalleryViewController.m
//  MANTRADWAR
//
//  Created by jayraj gohil on 07/04/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "GalleryViewController.h"
#import "ViewController.h"
#import "ImagesLocalViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setTabBar];
    [self.process startAnimating];
    [self getAlbumImagesFromServer];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"PHOTO GALLERY";
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
#pragma mark get Mantra List From Remote Server
-(void)getAlbumImagesFromServer
{
    @try {
        if ([self connected])
        {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",urlAlbumImage,@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            // NSLog(@"%@", request.URL);
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err){
                if (err) {
                    return;
                }
                else
                {
                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                    self.arrayData =[[NSMutableArray alloc]initWithArray:[parsedObject valueForKey:@"gallery_data"]];
                    [self combineArray:self.arrayData];
                    [self.tblView reloadData];
                    [self.process stopAnimating];
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
#pragma mark Alert Methods
-(void)alert:(NSString *)title msg :(NSString *)msg alertTag:(int)tag cancelTitile:(NSString *)cancelTitle okTitle:(NSString *)okTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alert.delegate = self;
    alert.tag = tag;
    [alert show];
    alert = nil;
}
#pragma mark Action
#pragma mark Combine Array for Gallery
-(void)combineArray:(NSArray *)tempArray
{
    self.arrayData = [[NSMutableArray alloc] init];
    for (int i = 0; i<[tempArray count]; i++) {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
        [temp setObject:[tempArray objectAtIndex:i] forKey:@"1"];
        i++;
        if (i<[tempArray count]) {
            [temp setObject:[tempArray objectAtIndex:i] forKey:@"2"];
        }
        [self.arrayData addObject:temp];
    }
    tempArray = nil;
    [self.tblView reloadData];
}
#pragma mark TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayData count];    //count number of row from counting array hear cataGorry is An Array
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 170.0f;
    }
    else
    {
        return 240.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UIImageView *imgView1,*imgView2;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier] ;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10,150, 150)];
            imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(163, 10, 150, 150)];
        }
        else
        {
            imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10,150, 230)];
            imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(163, 10, 150, 230)];
        }
        
        imgView1.tag = 1013;
        [imgView1.layer setBorderWidth:1];
        imgView1.autoresizingMask =(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleWidth);
        [imgView1.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [cell addSubview:imgView1];
        
        
        imgView2.tag = 1014;
        [imgView2.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [imgView2.layer setBorderWidth:1];
        imgView2.autoresizingMask =( UIViewAutoresizingFlexibleBottomMargin  |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth);
        [cell addSubview:imgView2];
        
    }
    else
    {
        imgView1 = (UIImageView *)[cell viewWithTag:1013];
        imgView2 = (UIImageView *)[cell viewWithTag:1014];
    }
    imgView1.image = [UIImage imageNamed:@"Icon.png"];
        imgView2.image = [UIImage imageNamed:@"Icon.png"];
    if ([self.arrayData count]>0)
    {
        NSMutableDictionary *tempObject =[self.arrayData objectAtIndex:indexPath.row];
        
        NSMutableDictionary *appRecord1 =[[NSMutableDictionary alloc]initWithDictionary:[tempObject valueForKey:@"1"]];
        NSMutableDictionary *appRecord2 = [[NSMutableDictionary alloc]initWithDictionary:[tempObject valueForKey:@"2"]];
        
        
        if (appRecord1) {
            if (![appRecord1 objectForKey:@"Icon1013"])
            {
                if (self.tblView.dragging == NO && self.tblView.decelerating == NO)
                {
                    if ([[NSUserDefaults standardUserDefaults] valueForKey: [appRecord1 objectForKey:@"image_full_url"]] != nil) {
                        imgView1.image = [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] valueForKey: [appRecord1 objectForKey:@"image_full_url"]]];
                        [appRecord1 setObject:imgView1.image forKey:@"Icon1013"];
                    }else {
                        
                        [self startIconDownload:appRecord1 forIndexPath:indexPath andImageViewTag:1013];
                        imgView1.image = [UIImage imageNamed:@"Placeholder.png"];
                    }
                }else {
                    if ([[NSUserDefaults standardUserDefaults] valueForKey: [appRecord1 objectForKey:@"image_full_url"]] != nil) {
                        imgView1.image = [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] valueForKey: [appRecord1 objectForKey:@"image_full_url"]]];
                        
                        [appRecord1 setObject:imgView1.image forKey:@"Icon1013"];
                    }else {
                        imgView1.image = [UIImage imageNamed:@"placeholder.png"];
                    }
                }
            }
            else
            {
                imgView1.image = [appRecord1 objectForKey:@"Icon1013"];
            }
        }
        
        if (appRecord2) {
            if (![appRecord2 objectForKey:@"Icon1014"])
            {
                if (self.tblView.dragging == NO && self.tblView.decelerating == NO)
                {
                    if ([[NSUserDefaults standardUserDefaults] valueForKey: [appRecord2 objectForKey:@"image_full_url"]] != nil) {
                        imgView2.image = [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] valueForKey: [appRecord2 objectForKey:@"image_full_url"]]];
                        [appRecord2 setObject:imgView2.image forKey:@"Icon1014"];
                    }else {
                        
                        [self startIconDownload:appRecord2 forIndexPath:indexPath andImageViewTag:1014];
                        imgView2.image = [UIImage imageNamed:@"Placeholder.png"];
                    }
                }else {
                    if ([[NSUserDefaults standardUserDefaults] valueForKey: [appRecord2 objectForKey:@"image_full_url"]] != nil) {
                        imgView2.image = [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] valueForKey: [appRecord2 objectForKey:@"image_full_url"]]];
                        
                        [appRecord2 setObject:imgView2.image forKey:@"Icon1014"];
                    }else {
                        imgView2.image = [UIImage imageNamed:@"placeholder.png"];
                    }
                }
            }
            else
            {
                imgView2.image = [appRecord2 objectForKey:@"Icon1014"];
            }
        }
        appRecord1 = nil;
        appRecord2 = nil;
    }
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapped:)];
    tap1.numberOfTapsRequired = 1;
    tap1.delegate = self;
    [imgView1 addGestureRecognizer:tap1];
    imgView1.userInteractionEnabled = true;
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapped:)];
    tap2.numberOfTapsRequired = 1;
    tap2.delegate = self;
    [imgView2 addGestureRecognizer:tap2];
    imgView2.userInteractionEnabled = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark Tap Gesture Methods
-(void)imgTapped:(UITapGestureRecognizer *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender.view superview];
    UIImageView  *image= (UIImageView *)[cell viewWithTag:sender.view.tag];
    ImagesLocalViewController *localImage = [[ImagesLocalViewController alloc]init];
    localImage.imageArray = [[NSMutableArray alloc ]initWithObjects:image.image,nil];
    localImage.title = @"PHOTO GALLERY";
    [self.navigationController pushViewController:localImage animated:YES];
}
#pragma mark Set TabBar Appearence
-(void)setTabBar
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor grayColor] }forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Rockwell" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setShadowImage:nil];
}
#pragma mark - Tab bar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        ViewController *photoOBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:photoOBJ animated:NO];
    }
}
#pragma mark Table cell image support

- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath andImageViewTag:(int)tag
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%ld.%d", indexPath.row, tag]];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.imageViewTag=tag;
        iconDownloader.imageUrlKey = @"image_full_url";
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:[NSString stringWithFormat:@"%ld.%d", indexPath.row, tag]];
        [iconDownloader startDownload];
    }
}
- (void)loadImagesForOnscreenRows
{
    if ([self.arrayData count] > 0)
    {
        NSArray *visiblePaths = [self.tblView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSMutableDictionary *tempObj = [self.arrayData objectAtIndex:indexPath.row];
            NSMutableDictionary *appRecord1 =[[NSMutableDictionary alloc]initWithDictionary:[tempObj valueForKey:@"1"]];
            NSMutableDictionary *appRecord2 = [[NSMutableDictionary alloc]initWithDictionary:[tempObj valueForKey:@"2"]];
            //UITableViewCell *cell = [self.tblView cellForRowAtIndexPath:indexPath];
            if (appRecord1) {
                if (![appRecord1 objectForKey:@"Icon1013"]) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord1 forIndexPath:indexPath andImageViewTag:1013];
                }
            }
            if (appRecord2) {
                if (![appRecord2 objectForKey:@"Icon1014"]) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord2 forIndexPath:indexPath andImageViewTag:1014];
                }
            }
        }
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageViewTag:(int)imageViewTag
{
    IconDownloader *iconDownloader =  [self.imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%ld.%d", indexPath.row, imageViewTag]];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tblView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:imageViewTag];
        imgView.image = [iconDownloader.appRecord objectForKey:[NSString stringWithFormat:@"Icon%d", imageViewTag]];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
    
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
