//
//  Coach3Table1Delegate.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/26/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "Coach3Table2Delegate.h"


@implementation Coach3Table2Delegate

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Coach3Table2Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"mobile";
                cell.detailTextLabel.text = @"512-555-1212";
                break;
            case 1:
                cell.textLabel.text = @"home";
                cell.detailTextLabel.text = @"512-555-2222";
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"email";
                cell.detailTextLabel.text = @"david@gmail.com";
                break;
            case 1:
                cell.textLabel.text = @"email";
                cell.detailTextLabel.text = @"info@austinangelsbaseball.com";
                break;
            default:
                break;
        }
    }
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"Contact Info";
//    }
//    return nil;
//}

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
