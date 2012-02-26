//
//  TeamsTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 CoreLogic. All rights reserved.
//

#import "TeamsTableViewController.h"
#import "TeamPlayersTableViewController.h"
#import <YAJLios/YAJL.h>
#include "ASIHTTPRequest.h"
#import "AwsURLHelper.h"
#import "Team.h"

@interface TeamsTableViewController()

//@property (nonatomic, retain) NSMutableArray * zteams;
@property (nonatomic, retain) NSDictionary * teamsAsDictionary;
@end

@implementation TeamsTableViewController

@synthesize sections = _sections;
@synthesize teams = _teams;

//@synthesize zteams;
@synthesize teamsAsDictionary = _teamsAsDictionary;

/*
 * teams[NSArray]
 *
 * [0] = NSDictionary(level=13U, name=Austin Angels 13U Red, etc)
 * [1] = NSDictionary(level=13U, name=Austin Angels 13U White, etc)
 
 key=13U, value=NSArray
          [0] = Austin Angels 13U Red
          [1] = Austin Angels 13U White
 
 key=12U, value=NSArray
          [0] = Austin Angels 12U Red
          [1] = Austin Angels 12U White
 */

- (NSArray *)sections
{
//    NSLog(@"getSections()");
//    NSLog(@"sections = %@", _sections);
    if (!_sections) {
        _sections = [[self.teamsAsDictionary allKeys] retain];
        NSLog(@"sections = %@", _sections);
    }
//    NSLog(@"sections.retainCount = %d", [_sections retainCount]);
    
    return _sections;
}

- (NSArray *)teams
{
    return [Team allTeams];
}

//- (NSArray *)teamsOLD
//{
////    NSLog(@"getTeams()");
//    if (!_teams) {
//        NSMutableArray *jteams = [[NSMutableArray alloc] init];
//        NSURL *teamsURL = [AwsURLHelper getTeams];
//        NSLog(@"teams.url %@", teamsURL);
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:teamsURL];
//        [request addRequestHeader:@"Accept" value:@"application/json"];
//        [request startSynchronous];
//        NSError *error = [request error];
//        if (!error) {
//            NSString *response = [request responseString];
//            NSLog(@"teams.response = %@", response);
//            NSDictionary *temp = [response yajl_JSON];
//            NSLog(@"teams[after json parse] = %@", temp);
//            NSArray *x = [temp objectForKey:@"teams"];
//            NSLog(@"x = %@", x);
//            for (NSDictionary *d in x) {
//                NSLog(@"t = %@", d);
//                Team *t = [Team teamFromJson:d];
//                [jteams addObject:t];
//            }
//        }
//        NSLog(@"teams = %@ (retain count=%d)", jteams, [jteams retainCount]);
//        _teams = [[NSArray alloc] initWithArray:jteams];
//        [jteams release];
//    }
//    return _teams;
//}

- (NSDictionary *)teamsAsDictionary
{
    if (!_teamsAsDictionary) {
        _teamsAsDictionary = [[NSMutableDictionary alloc] init];
        for (Team *t in self.teams) {
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
        NSLog(@"teamsInDictionary = %@", _teamsAsDictionary);
    }
    return _teamsAsDictionary;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    NSLog(@"teams = %@ (retain count=%d)", self.teams, [self.teams retainCount]);
    NSLog(@"teamsAsDicitonary = %@ (retain count=%d)", self.teamsAsDictionary, [self.teamsAsDictionary retainCount]);

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
    NSInteger count = self.sections.count;
    NSLog(@"numberOfSectionsInTableView = %d", count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *teamsInSection = [self.teamsAsDictionary objectForKey:[self.sections objectAtIndex:section]];
    NSLog(@"numberOfRowsInSection.teamsInSection = %@", teamsInSection);
    NSUInteger count = teamsInSection.count;
    NSLog(@"numberOfRowsInSection.teamsInSection.count = %d", count);
    return count;
}

- (Team *)teamAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"teamAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
//    NSLog(@"_teams.retainCount = %d", [_teams retainCount]);
    NSArray *teamsInSection = [self.teamsAsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
    NSLog(@"teamAtIndexPath.teamsInSection = %@", teamsInSection);
    Team *t = [teamsInSection objectAtIndex:indexPath.row];
    NSLog(@"teamAtIndexPath = %@", t);
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
    NSLog(@"cell = %@", t);
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
    NSLog(@"indexPath: section=%d, row=%d", indexPath.section, indexPath.row);
    TeamPlayersTableViewController *pvc = [[TeamPlayersTableViewController alloc] init];
//    NSLog(@"_sections.retainCount = %d", [self.sections retainCount]);
//    NSLog(@"_teams.retainCount = %d", [self.teams retainCount]);
    Team *t = [self teamAtIndexPath:indexPath];
    NSLog(@"didSelectRowAtIndexPath = %@", t);
    pvc.team = t;
    [self.navigationController pushViewController:pvc animated:YES];
    [pvc release];   
}

- (void)dealloc
{
    [super dealloc];
}
@end
