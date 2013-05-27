//
//  MasterViewController.h
//  Small
//
//  Created by Artem Titoulenko on 5/26/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) NSString * titleBarLabelText;
@property (strong, nonatomic) NSMutableArray * postTitles;

@property (weak, nonatomic) IBOutlet UILabel *titleBarLabel;
@end
