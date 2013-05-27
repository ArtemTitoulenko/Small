//
//  MasterViewController.m
//  Small
//
//  Created by Artem Titoulenko on 5/26/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import <Foundation/NSJSONSerialization.h> 

@implementation NSDictionary(Utilities)
-(void)listKeys {
  for (id sub_key in self) {
    NSLog(@"key: %@", sub_key);
  }
}

-(void)listKeysForKey:(NSString *)key {
  [[self objectForKey:key] listKeys];
}

-(void)listKeysForPath:(NSString *)path {
  NSMutableArray * keys = [path componentsSeparatedByString:@"."];
  
  NSLog(@"num keys: %i", [keys count]);
  
  id parent = self;
  while ([keys count] > 0) {
    parent = [parent objectForKey:[keys objectAtIndex:0]];
    [keys removeObjectAtIndex:0];
  }
  
  [parent listKeys];
}

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

@interface MasterViewController () {
  NSURLConnection * connection;
  NSMutableData * connectionData;
  NSInteger * connectionDataLength;
  NSMutableArray * collectionTitles;
}
@end

@implementation MasterViewController

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

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  connectionData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [connectionData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSString * result = [[NSString alloc] initWithData:connectionData encoding:NSASCIIStringEncoding];
  result = [result substringFromIndex:16];
  NSData * correctData = [result dataUsingEncoding:NSUTF8StringEncoding];

  NSError * error = nil;
  NSDictionary * json = [NSJSONSerialization JSONObjectWithData:correctData options:NSJSONReadingMutableLeaves error:&error];
    
  NSArray * collections = [json objectForPath:@"payload.value"];
  NSLog(@"num collections: %i", [collections count]);
  
  for (int i = 0; i < [collections count]; i++) {
    [self insertNewTitle:[[collections objectAtIndex: i] objectForKey:@"description"]];
  }
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  cell.textLabel.text = collectionTitles[indexPath.row];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
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
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString * title = collectionTitles[indexPath.row];
    [[segue destinationViewController] setDetailItem:title];
  }
}

@end
