//
//  CoachSummaryViewController.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "CoachSummaryViewController.h"

//@interface CoachSummaryViewController()
////@property (retain) IBOutlet UILabel *firstNameLabel;
////@property (retain) IBOutlet UILabel *lastNameLabel;
//@end

@implementation CoachSummaryViewController

@synthesize coach;

//@synthesize firstNameLabel;
//@synthesize lastNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    firstNameLabel.text = coach.firstname;
    lastNameLabel.text = coach.lastname;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
