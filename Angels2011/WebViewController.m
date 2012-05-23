//
//  WebViewController.m
//  Angels2012
//
//  Created by Glenn Kronschnabl on 5/19/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "WebViewController.h"
#import "Logging.h"

@interface WebViewController ()
@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController
@synthesize webView;

- (IBAction)doneButtonPressed:(id)sender
{
    DLog(@"Done button pressed");
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        // Custom initialization
        //self.title = @"Google Team Calendar";
        UIImage* anImage = [UIImage imageNamed:@"83-calendar.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Google Team Calendar" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = rBarItem;
//    [rBarItem release];

    // Do any additional setup after loading the view from its nib.
    NSString *str = @"https://www.google.com/calendar/embed?src=austinangelsbaseball%40yahoo.com&ctz=America/Chicago&mode=WEEK";
    NSURL *_url = [[NSURL alloc] initWithString:str];
    NSURLRequest *url = [[NSURLRequest alloc] initWithURL:_url];
    [webView loadRequest:url];
    [url release];
    [_url release];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [webView release];
    [super dealloc];
}
@end
