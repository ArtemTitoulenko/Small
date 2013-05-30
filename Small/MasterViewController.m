//
//  MasterViewController.m
//  Small
//
//  Created by Artem Titoulenko on 5/26/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation NSDictionary(Utilities)
-(id)objectForPath:(NSString *)path {
  NSMutableArray * keys = [path componentsSeparatedByString:@"."];
  
  id parent = self;
  while ([keys count] > 1) {
    parent = [parent objectForKey:[keys objectAtIndex:0]];
    [keys removeObjectAtIndex:0];
  }
  
  return [parent objectForKey:[keys objectAtIndex:0]];
}
@end

@interface MasterViewController ()
- (void) configureView;
@end

@implementation MasterViewController

@synthesize titleBarLabelText;
@synthesize postTitles;

#pragma mark - Segue Data

- (void)setTitle:(id)title {
  if (titleBarLabelText != title) {
    titleBarLabelText = title;
    [self configureView];
  }
}

- (void)setArray:(id)newPosts {
  if (self.postTitles != newPosts) {
    NSLog(@"got %i new posts!", [newPosts count]);
    self.postTitles = newPosts;
    [self configureView];
  }
}

- (void) configureView {
  if (self.postTitles) {
    NSLog(@"configuring postTitles");
    for (int i = 0; i < [postTitles count]; i++) {
      [self insertNewTitle:[postTitles objectAtIndex:i]];
    }
  }
}

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)insertNewTitle:(NSString *)title
{
  if (!postTitles) {
    postTitles = [[NSMutableArray alloc] init];
  }
  [postTitles insertObject:title atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [postTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  cell.textLabel.text = postTitles[indexPath.row];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [postTitles removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString * title = postTitles[indexPath.row];
    [[segue destinationViewController] setDetailItem:title];
  }
}

@end
