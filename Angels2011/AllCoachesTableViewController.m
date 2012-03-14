//
//  AllCoachesTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/17/11.
//  Copyright (c) 2011 CoreLogic. All rights reserved.
//

#import "AllCoachesTableViewController.h"
#import "Coach.h"
#import "Coach4MoreInfoViewController.h"

@interface AllCoachesTableViewController()
@property (retain, nonatomic) NSDictionary * coachesAsDictionary;
@property (retain, nonatomic) UIView * origView;
@property (retain, nonatomic) UIActivityIndicatorView * spinner;
@end

@implementation AllCoachesTableViewController

@synthesize sections = _sections;
@synthesize coaches = _coaches;
@synthesize origView, spinner;

@synthesize coachesAsDictionary = _coachesAsDictionary;


- (NSDictionary *)coachesAsDictionary
{
    if (!_coachesAsDictionary) {
        _coachesAsDictionary = [[NSMutableDictionary alloc] init];
        for (Coach *t in _coaches) {
            NSString *key = [t.lastname substringToIndex:1];
            if ([_coachesAsDictionary objectForKey:key]) {
                [[_coachesAsDictionary objectForKey:key] addObject:t];
            }
            else {
                NSMutableArray *a = [[[NSMutableArray alloc] init] autorelease];
                [a addObject:t];
                [_coachesAsDictionary setValue:a forKey:key];
            }
        }
        NSLog(@"_coachesInDictionary = %@", _coachesAsDictionary);
    }
    return _coachesAsDictionary;
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [[[self.coachesAsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
        NSLog(@"sections = %@", _sections);
    }
    return _sections;
}

- (void)loadCoaches
{
    NSLog(@"loadCoaches()");
    if (!_coaches) {
        _coaches = [[Coach allCoaches] retain];
        [spinner stopAnimating];
        [_sections release];
        _sections = nil;
        [_coachesAsDictionary release];
        _coachesAsDictionary = nil;
        
        [self setView: origView];
        [self.tableView reloadData];
        
        [spinner release];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIImage* anImage = [UIImage imageNamed:@"111-user.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Coaches" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];
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
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    origView = [self.view retain];
    
    [self setView:spinner];
    [self performSelectorInBackground:@selector(loadCoaches) withObject:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *coachesInSection = [self.coachesAsDictionary objectForKey:[self.sections objectAtIndex:section]];
    return coachesInSection.count;
}

- (Coach *)coachAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *coachesInSection = [self.coachesAsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
    Coach *c = [coachesInSection objectAtIndex:indexPath.row];
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CoachesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Coach *c = [self coachAtIndexPath:indexPath];
    NSString *s = [NSString stringWithFormat:@"%@ %@", c.firstname, c.lastname]; 
    cell.textLabel.text = s;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    Coach4MoreInfoViewController *csvc = [[Coach4MoreInfoViewController alloc] init];
    csvc.coach = [self coachAtIndexPath:indexPath];
    NSLog(@"selected coach: %@", csvc.coach);
    [self.navigationController pushViewController:csvc animated:YES];
    [csvc release]; 
}

@end
