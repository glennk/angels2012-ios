//
//  TeamsTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "TeamsTableViewController.h"
#import "TeamPlayersTableViewController.h"
#import "Team.h"
#import "Logging.h"

@interface TeamsTableViewController()
@property (nonatomic, retain) NSDictionary * teamsAsDictionary;
@property (retain, nonatomic) UIView * origView;
@property (retain, nonatomic) UIActivityIndicatorView * spinner;
@end

@implementation TeamsTableViewController

@synthesize sections = _sections;
@synthesize teams = _teams;

@synthesize teamsAsDictionary = _teamsAsDictionary;
@synthesize origView, spinner;

- (NSDictionary *)teamsAsDictionary
{
    if (!_teamsAsDictionary) {
        _teamsAsDictionary = [[NSMutableDictionary alloc] init];
        for (Team *t in _teams) {
            NSString *key = [t.level substringToIndex:3];
            if ([_teamsAsDictionary objectForKey:key]) {
                [[_teamsAsDictionary objectForKey:key] addObject:t];
            }
            else {
                NSMutableArray *a = [[[NSMutableArray alloc] init] autorelease];
                [a addObject:t];
                [_teamsAsDictionary setValue:a forKey:key];
            }
        }
        DLog(@"teamsInDictionary = %@", _teamsAsDictionary);
    }
    return _teamsAsDictionary;
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [[self.teamsAsDictionary allKeys] retain];
        DLog(@"sections = %@", _sections);
    }
    
    return _sections;
}

- (void)loadTeams
{
    DLog(@"loadTeams()");
    _teams = [[Team allTeams] retain];
    [_sections release];
    _sections = nil;
    [_teamsAsDictionary release];
    _teamsAsDictionary = nil;
    [spinner stopAnimating];
    [spinner release];
    [self setView: origView];
    [self.tableView reloadData];
    DLog(@"loadTeams()...done");
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIImage* anImage = [UIImage imageNamed:@"85-trophy.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Teams" image:anImage tag:0];
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
    self.title = @"Teams";
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
    
    if (!_teams) {
        DLog(@"_teams is nil, fetch via REST");
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        
        origView = [self.view retain];
    
        [self setView:spinner];
        [self performSelectorInBackground:@selector(loadTeams) withObject:nil];
    }
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
    NSInteger count = self.sections.count;
    DLog(@"numberOfSectionsInTableView = %d", count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *teamsInSection = [self.teamsAsDictionary objectForKey:[self.sections objectAtIndex:section]];
    DLog(@"numberOfRowsInSection.teamsInSection = %@", teamsInSection);
    NSUInteger count = teamsInSection.count;
    DLog(@"numberOfRowsInSection.teamsInSection.count = %d", count);
    return count;
}

- (Team *)teamAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"teamAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
//    DLog(@"_teams.retainCount = %d", [_teams retainCount]);
    NSArray *teamsInSection = [self.teamsAsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
    DLog(@"teamAtIndexPath.teamsInSection = %@", teamsInSection);
    Team *t = [teamsInSection objectAtIndex:indexPath.row];
    DLog(@"teamAtIndexPath = %@", t);
    return t;
//    return [teamsInSection objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AngelsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Team *t = [self teamAtIndexPath:indexPath];
    DLog(@"cell = %@", t);
    cell.textLabel.text = t.name;
    
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
    DLog(@"indexPath: section=%d, row=%d", indexPath.section, indexPath.row);
    TeamPlayersTableViewController *pvc = [[TeamPlayersTableViewController alloc] init];
//    DLog(@"_sections.retainCount = %d", [self.sections retainCount]);
//    DLog(@"_teams.retainCount = %d", [self.teams retainCount]);
    Team *t = [self teamAtIndexPath:indexPath];
    DLog(@"didSelectRowAtIndexPath = %@", t);
    pvc.team = t;
    [self.navigationController pushViewController:pvc animated:YES];
    [pvc release];   
}

- (void)dealloc
{
    [super dealloc];
}
@end
