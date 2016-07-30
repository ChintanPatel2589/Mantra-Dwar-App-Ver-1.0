//
//  DownloadMantraViewController.m
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/25/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "DownloadMantraViewController.h"
#import "Reachability.h"
@interface DownloadMantraViewController ()

@end

@implementation DownloadMantraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.process startAnimating];
    [self getMantraListFromServer];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"MANTRADWAR";
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark get Mantra List From Remote Server
-(void)getMantraListFromServer
{
    @try {
        if ([self connected])
        {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",urlMantraList] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
           // NSLog(@"%@", request.URL);
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err){
                if (err) {
                    return;
                }
                else
                {
                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                    self.arrayData =[[NSMutableArray alloc]initWithArray:[parsedObject valueForKey:@"mantra_data"]];
                    [self.tblView reloadData];
                    [self.process stopAnimating];
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
    UIImageView *imgPlay,*imgCellBack,*imgDownloadIcon;
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
        
        imgDownloadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(270, 8, 35, 27)];
        imgDownloadIcon.image = [UIImage imageNamed:@"downloaIcon.png"];
        imgDownloadIcon.tag = 1015;
        imgDownloadIcon.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin );
        [cell addSubview:imgDownloadIcon];

        
    }
    else
    {
        imgCellBack = (UIImageView *)[cell viewWithTag:1012];
        imgPlay = (UIImageView *)[cell viewWithTag:1013];
        lblMantraName = (UILabel *)[cell viewWithTag:1014];
        imgDownloadIcon = (UIImageView *)[cell viewWithTag:1015];

    }
    if([[self arrayData] count]>0)
    {
         lblMantraName.text = [[self.arrayData objectAtIndex:indexPath.row]valueForKey:@"mantra_name"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (![self checkMantraExist:[NSString stringWithFormat:@"%@.mp3",[[[self.arrayData objectAtIndex:indexPath.row] valueForKey:@"mantra_name"]stringByReplacingOccurrencesOfString:@" " withString:@""]]]) {
        
        [self downloadMatra:[self.arrayData objectAtIndex:indexPath.row]];
    }
    else
    {
        [self alert:@"Alert" msg:[NSString stringWithFormat:@"%@ is Already Downloaded.",[[self.arrayData objectAtIndex:indexPath.row] valueForKey:@"mantra_name"]] alertTag:0 cancelTitile:nil okTitle:@"Ok"];
    }
}
#pragma mark GET all Mantra fro Directory
-(BOOL)checkMantraExist :(NSString *)songName
{
    NSArray *tmp =[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[self getMantraPath] error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF EndsWith '.mp3'"];
    tmp =  [tmp filteredArrayUsingPredicate:predicate];
    return [tmp containsObject:songName];
    tmp = nil;
    predicate = nil;
}
#pragma mark TOOL BAR Method
-(IBAction)toolBarCancel
{
    self.tblView.userInteractionEnabled = true;
    self.viewProgress.hidden = true;
    self.downloadedMutableData = nil;
    [self.connectionManager cancel];
    self.connectionManager = nil;
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
-(void)downloadMatra :(NSDictionary *)songDict
{
    self.currentDownloading = [[NSMutableDictionary alloc]initWithDictionary:songDict];
    self.tblView.userInteractionEnabled = false;
    [self.view bringSubviewToFront:self.viewProgress];
    self.lblDownloadingSongName.text = [self.currentDownloading valueForKey:@"mantra_name"];
    self.viewProgress.hidden = false;
    NSURL *mapUrl = [NSURL URLWithString:[[songDict valueForKey:@"mp3_full_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.downloadedMutableData = [[NSMutableData alloc] init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:mapUrl
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
    self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}
#pragma mark - Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%lld", response.expectedContentLength);
    self.urlResponse = response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedMutableData appendData:data];
    self.progressBar.progress = ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)/100;
    if (self.progressBar.progress == 1) {
        self.progressBar.hidden = YES;
    } else {
        self.progressBar.hidden = NO;
    }
    self.lblProgress.text = [NSString stringWithFormat:@"%.0f%%",((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)];
    //NSLog(@"%.0f%%", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length));
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self alert:@"Error" msg:@"Mantra Downloading Fail. Please Try Again." alertTag:0 cancelTitile:nil okTitle:@"Ok"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished");
    self.tblView.userInteractionEnabled = true;
    
    NSString *dataPath = [[self getMantraPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[[self.currentDownloading valueForKey:@"mantra_name"] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    [self.downloadedMutableData writeToFile:dataPath atomically:YES];
   
    //Save
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadedMantra"]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadedMantra"]];
        [tmpArray addObject:self.currentDownloading];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DownloadedMantra"];
        [[NSUserDefaults standardUserDefaults] setObject:tmpArray forKey:@"DownloadedMantra"];
    }
    else
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        [tmpArray addObject:self.currentDownloading];
        [[NSUserDefaults standardUserDefaults] setObject:tmpArray forKey:@"DownloadedMantra"];
    }
    
    
    
    [self alert:nil msg:@"Mantra Downloading Complete." alertTag:0 cancelTitile:nil okTitle:@"Ok"];
    [self toolBarCancel];
    self.currentDownloading = nil;
    dataPath = nil;
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

//NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:mapUrl];
//[req setHTTPMethod:@"Head"];
//NSURLConnection * con = [[NSURLConnection alloc] initWithRequest:req
//                                                        delegate:self];
//[con start];
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"didReceiveResponse (%lld)", response.expectedContentLength);
//}
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
