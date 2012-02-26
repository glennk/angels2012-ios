//
//  CoachSummaryViewController.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface CoachSummaryViewController : UIViewController {
    Coach *coach;
    
    IBOutlet UILabel *firstNameLabel;
    IBOutlet UILabel *lastNameLabel;
}

@property (retain, nonatomic) Coach *coach;

@end
