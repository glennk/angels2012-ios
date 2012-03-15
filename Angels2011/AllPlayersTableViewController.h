//
//  AllPlayersTableViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/3/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPlayersTableViewController : UITableViewController {
    NSArray *sections;
    NSArray *players;
}

@property (retain, nonatomic) NSArray *sections;
@property (retain, nonatomic) NSArray *players;

@end
