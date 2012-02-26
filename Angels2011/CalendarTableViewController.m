//
//  CalendarTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/13/11.
//  Copyright (c) 2011 CoreLogic. All rights reserved.
//

#import "CalendarTableViewController.h"
#include "ASIHTTPRequest.h"
#import <YAJLios/YAJL.h>
#import "AwsURLHelper.h"

@interface CalendarTableViewController()
@property (retain, nonatomic) NSMutableDictionary *gcal;
@property (retain, nonatomic) NSArray *sections;
@property (retain, nonatomic) NSDateFormatter *inDateFormatter, *outDateFormatter;

@end


@implementation CalendarTableViewController

@synthesize gcal = _gcal;
@synthesize sections = _sections;
@synthesize inDateFormatter, outDateFormatter;


- (NSArray *)sections
{
    if (!_sections) {
        //_sections = [[NSMutableArray alloc] init];
//        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
//        NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
//        //[inDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-Z"];
//        [inDateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
//        [outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        NSArray *t = [self.gcal allKeys];
//        for (NSString *s in t) {
//            //s = @"2001-01-01T11:30:01.000-05:00";
//            //      1234567890
//            NSString *c = [s substringToIndex:10];
//            NSDate *dstart = [inDateFormatter dateFromString:c];
//            NSString *x = [outDateFormatter stringFromDate:dstart];
//            //NSDate *d1 = [[NSDate alloc] initWithString:s];
//            NSLog(@"key = %@", x);
//            [temp setObject: forKey:x];
//        }
        _sections = [[[self.gcal allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
//        [temp release];
        //NSLog(@"sections = %@", _sections);
        NSLog(@"_sections = %@", _sections);
    }
    return _sections;
}

/*
 * key[Sep 15, 2001], values=NSArray[0]=NSDate, Title
 *                           NSArray[1]=NSDate, Title
 * key[Sep 17, 2001], values=NSArray[0]=NSDate, Title
 *                           
 */

- (NSMutableDictionary *)gcalFromDisk
{
    NSLog(@"getGcal()");
    if (!_gcal) {
        NSLog(@"_gcal is nil, call URL to populate");
        _gcal = [[[NSMutableDictionary alloc] init] autorelease];
        NSError *error = nil;
        NSString *txt = [[[NSString alloc] initWithContentsOfFile:@"/Users/grk/google_calendar.txt" encoding:NSUTF8StringEncoding error:&error] autorelease];
        if (error) {
            NSLog(@"error = %@", [error description]);
        }
        else {
            NSDictionary *temp = [txt yajl_JSON];
            //NSLog(@"gcal[after json parse] = %@", temp);
            NSDictionary *x = [temp objectForKey:@"data"];
            //NSLog(@"x = %@", x);
            NSArray *y = [x objectForKey:@"items"];
            //NSLog(@"y = %@", y);
            for (NSDictionary *d in y) {
                //NSLog(@"keys = %@", [d allKeys]);
                //NSString *title = [d objectForKey:@"title"];
                //NSLog(@"title = %@, when = %@", title, [d objectForKey:@"when"]);
                NSString *start = [[[d objectForKey:@"when"] objectAtIndex:0] objectForKey:@"start"];
//                NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
//                [inDateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *key = [start substringToIndex:10];
//                NSDate *dstart = [inDateFormatter dateFromString:c];
//                NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
//                [outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
//                NSString *x = [outDateFormatter stringFromDate:dstart];
                NSLog(@"key = %@", key);
                if (![_gcal objectForKey:key]) {
                    NSMutableArray *x = [[NSMutableArray alloc] init];
                    [x addObject:d];
                    [_gcal setValue:x forKey:key];
                    
                } else {
                    [[_gcal objectForKey:x] addObject:x];
                }
            }
        }
        NSLog(@"gcal = %@", _gcal);
    }
    return _gcal;
}

- (NSMutableDictionary *)gcal
{
    NSLog(@"getGcal()");
    if (!_gcal) {
        NSLog(@"_gcal is nil, call URL to populate");
        _gcal = [[NSMutableDictionary alloc] init];
        //NSURL *url = [[NSURL alloc] initWithString:@"https://www.google.com/calendar/feeds/austinangelsbaseball%40yahoo.com/public/full?alt=jsonc"];
        NSURL *url = [AwsURLHelper getGoogleCal];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request startSynchronous];
        NSError *error = [request error];
        if (error) {
            NSLog(@"error = %@", [error description]);
        }
        else {
            NSString *response = [request responseString];
            //NSLog(@"gcal response: %@", response);
            NSDictionary *temp = [response yajl_JSON];
            //NSLog(@"gcal[after json parse] = %@", temp);
            //NSDictionary *x = [temp objectForKey:@"data"];
            //NSLog(@"x = %@", x);
            NSArray *y = [temp objectForKey:@"items"];
            //NSLog(@"y = %@", y);
            for (NSDictionary *d in y) {
                if ([d objectForKey:@"recurrence"])
                    continue;
                //NSLog(@"keys = %@", [d allKeys]);
                //NSString *title = [d objectForKey:@"title"];
                //NSLog(@"title = %@, when = %@", title, [d objectForKey:@"when"]);
                NSDictionary *start = [d objectForKey:@"start"];
                NSString *key = [start objectForKey:@"date"];
                                       
                //NSString *key = [[[d objectForKey:@"start"] objectAtIndex:0] objectForKey:@"date"];
                //                NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
                //                [inDateFormatter setDateFormat:@"yyyy-MM-dd"];
                //NSString *key = [start substringToIndex:10];
                //                NSDate *dstart = [inDateFormatter dateFromString:c];
                //                NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
                //                [outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
                //                NSString *x = [outDateFormatter stringFromDate:dstart];
                NSLog(@"key = %@", key);
                if (key == nil)
                    continue;
                if (![_gcal objectForKey:key]) {
                    NSMutableArray *x = [[NSMutableArray alloc] init];
                    [x addObject:d];
                    [_gcal setValue:x forKey:key];
                    
                } else {
                    [[_gcal objectForKey:key] addObject:d];
                }
            }
        }
        NSLog(@"gcal = %@", _gcal);
    }
    return _gcal;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIImage* anImage = [UIImage imageNamed:@"83-calendar.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:anImage tag:0];
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
    self.title = @"Tournament Calendar";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.inDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.inDateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.outDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
   // [self.outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *usFormatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
    NSLog(@"usFormatterString: %@", usFormatString);
    [self.outDateFormatter setDateFormat:usFormatString];
    [usLocale release];
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
    NSArray *entriesInSection = [self.gcal objectForKey:[self.sections objectAtIndex:section]];
    return entriesInSection.count;
}

- (NSDictionary *)entryAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"entryAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);

    NSString *key = [self.sections objectAtIndex:indexPath.section];
    NSLog(@"key = %@", key);
    NSArray *eventsInSection = [self.gcal objectForKey:key];
    //NSLog(@"sec = %@", eventsInSection);
    NSDictionary *t = [eventsInSection objectAtIndex:indexPath.row];
    NSLog(@"entryAtIndexPath = %@", [t objectForKey:@"title"]);
    return t;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *t = [self entryAtIndexPath:indexPath];
    //NSLog(@"cell = %@", t);
    cell.textLabel.text = [t objectForKey:@"description"];
    //NSArray *whenarray = [t objectForKey:@"start"];
    //assert(whenarray.count == 1);
    NSDictionary *key = [t objectForKey:@"start"];
    NSLog(@"key = %@", key);
//    NSString *start = nil, *end = nil;
//    Boolean isTime = NO;
//    if ([when count] > 0) {
//        start = [when objectForKey:@"start"];
//        if (start.length > 11) {
//            start = [start substringWithRange:NSMakeRange(11, 5)];
//            isTime = YES;
//        }
//    }
//    if ([when count] > 1) {
//        end = [when objectForKey:@"end"];
//        if (end.length > 11) {
//            end = [end substringWithRange:NSMakeRange(11, 5)];
//        }
//    }
    
    NSString *startDate = [key objectForKey:@"date"];
    NSString *detailText = nil;
//    if (!isTime && start && end && (start != end)) {
//        //
//        NSLog(@"multi-day event");
//        ;
//        detailText = @"multi-day-event"; //[[NSString alloc] initWithFormat:@"%@-%@, %@", start, end, [t objectForKey:@"location"]];
//    }
//    else {
        detailText = [[[NSString alloc] initWithFormat:@"%@", [t objectForKey:@"location"]] autorelease];
//        
//    }

    cell.detailTextLabel.text = detailText; //[t objectForKey:@"location"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *s = [self.sections objectAtIndex:section];
    NSDate *dstart = [inDateFormatter dateFromString:s];
    NSString *x = [outDateFormatter stringFromDate:dstart];
    return x; //[self.sections objectAtIndex:section];
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
}

@end
