//
//  DetailViewController.m
//  Small
//
//  Created by Artem Titoulenko on 5/26/13.
//  Copyright (c) 2013 Artem Titoulenko. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize collections;

#pragma mark - Managing the detail item

- (void)setArray:(id)newCollectionsArray {
  if (collections != newCollectionsArray) {
    collections = newCollectionsArray;
    
    [self configureView];
  }
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem) {
      self.detailDescriptionLabel.text = [self.detailItem description];
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
