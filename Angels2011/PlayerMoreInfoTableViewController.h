//
//  PlayerMoreInfoTableViewController.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/19/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerMoreInfoTableViewController : UITableViewController {

    Player *player;
}

@property (retain, nonatomic) Player *player;

- (IBAction)doneButtonPressed:(id)sender;

@end
