//
//  CountdownToOmahaViewController.m
//  Angels2012
//
//  Created by Glenn Kronschnabl on 5/10/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "CountdownToOmahaViewController.h"

@interface CountdownToOmahaViewController ()
@property (retain, nonatomic) IBOutlet UILabel *daysToFlorida;
@property (retain, nonatomic) IBOutlet UILabel *daystoOmaha;

@end

@implementation CountdownToOmahaViewController
@synthesize daysToFlorida;
@synthesize daystoOmaha;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* anImage = [UIImage imageNamed:@"37-suitcase.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Countdown" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];
    }
    return self;
}

NSString *omahaDateStr = @"21 June 2012";
NSString *orlandoDateStr = @"01 July 2012";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    NSDate* today = [NSDate date];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d LLLL yyyy"];
    NSDate *omahaDate = [dateFormat dateFromString:omahaDateStr]; 
    NSDate *orlandoDate = [dateFormat dateFromString:orlandoDateStr]; 
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:omahaDate options:0];
    NSInteger omahaDays = [components day];   
    
    components = [gregorian components:unitFlags fromDate:today toDate:orlandoDate options:0];
    NSInteger orlandoDays = [components day];
    
    [dateFormat release];
    [gregorian release];
    
    daysToFlorida.text = [NSString stringWithFormat:@"%d", orlandoDays];
    daystoOmaha.text = [NSString stringWithFormat:@"%d", omahaDays];
    self.navigationItem.title = @"Countdown to...";
}

- (void)viewDidUnload
{
    [self setDaysToFlorida:nil];
    [self setDaystoOmaha:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [daysToFlorida release];
    [daystoOmaha release];
    [super dealloc];
}
@end
