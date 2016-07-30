//
//  ImagesLocalViewController.m
//  TKScroller
//
//  Created by Toseefhusen on 27/02/14.
//  Copyright (c) 2014 Toseef Khilji. All rights reserved.
//


#import "ImagesLocalViewController.h"
@interface ImagesLocalViewController ()

@end

@implementation ImagesLocalViewController
@synthesize scroller;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{

    
    scroller=[[TKScroller alloc]initWithFrame:CGRectMake(5, 5, 100, 100) array:self.imageArray mode:kScrollModeImageLocal];
    scroller.page = self.page;
    // scroller.translatesAutoresizingMaskIntoConstraints=NO;
    
    scroller.translatesAutoresizingMaskIntoConstraints=NO;
    scroller.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scroller];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scroller);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[scroller]-1-|" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[scroller]-|"
                                                          options: NSLayoutFormatAlignAllRight
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
