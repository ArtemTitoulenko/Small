//
//  CollectionViewController.m
//  Small
//
//  Created by Artem Titoulenko on 5/27/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import "CollectionViewController.h"
#import "MasterViewController.h"

@interface CollectionViewController () {
  NSURLConnection * connection;
  NSMutableData * connectionData;
  NSInteger * connectionDataLength;
  NSMutableArray * collections;
  NSMutableArray * collectionTitles;
}
@end

@implementation CollectionViewController

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  
  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://medium.com/collections?apiv=1"]
                                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval: 60.0];
  
  connectionData = [[NSMutableData alloc] init];
  connection = [NSURLConnection connectionWithRequest:request delegate:self];
  
  if (!connection) {
    NSLog(@"Could not create the connection. Check your network settings");
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)insertNewTitle:(NSString *)title
{
  if (!collectionTitles) {
    collectionTitles = [[NSMutableArray alloc] init];
  }
  [collectionTitles insertObject:title atIndex:0];
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
  return collectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Collection Cell" forIndexPath:indexPath];
  
  cell.textLabel.text = collectionTitles[indexPath.row];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [collectionTitles removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showPosts"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString * title = collectionTitles[indexPath.row];
    [[segue destinationViewController] setTitle:title];
  }
}
@end
