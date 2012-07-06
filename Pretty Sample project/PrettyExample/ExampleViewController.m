//
//  ExampleViewController.m
//  PrettyExample
//
//  Created by Víctor on 29/02/12.
//  Copyright (c) 2012 Victor Pena Placer. All rights reserved.
//

#import "ExampleViewController.h"
#import "PrettyKit.h"
#import "ModalViewController.h"


@implementation ExampleViewController


- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

- (void)onComposeClick:(id)sender
{
  ModalViewController *modalView = [[ModalViewController alloc] initWithNibName:@"ModalViewController" bundle:nil];
  [self presentModalViewController:modalView animated:YES];
  [modalView release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.title = @"PrettyKit";

  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                           target:self
                           action:@selector(onComposeClick:)] autorelease];
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
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
  self.tableView.accessibilityLabel = @"Test";
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
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  if (section == 0) {
    return 3;
  }
  if (section == 1) {
    return 1;
  }
  if (section == 2) {
    return 1;
  }
  if (section == 3) {
    return 20;
  }
  if (section == 4) {
    return 1;
  }


  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  static NSString *SegmentedCellIdentifier = @"SegmentedCell";
  PrettySegmentedControlTableViewCell *segmentedCell;
  static NSString *GridCellIdentifier = @"GridCell";
  PrettyGridTableViewCell *gridCell;


  PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.tableViewBackgroundColor = tableView.backgroundColor;
  }

  switch (indexPath.section) {
    case 1:
      switch (indexPath.row) {
        case 0:
          segmentedCell = [tableView dequeueReusableCellWithIdentifier:SegmentedCellIdentifier];
          if (segmentedCell == nil) {
            segmentedCell = [[[PrettySegmentedControlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SegmentedCellIdentifier] autorelease];
          }
          [segmentedCell prepareForTableView:tableView indexPath:indexPath];
          segmentedCell.titles = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
          segmentedCell.tableViewBackgroundColor = tableView.backgroundColor;
          return segmentedCell;
        default:
          break;
      }

      break;
    case 2:
      gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
      if (gridCell == nil) {
        gridCell = [[[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GridCellIdentifier] autorelease];
        gridCell.tableViewBackgroundColor = tableView.backgroundColor;
        gridCell.actionBlock = ^(NSIndexPath *indexPath, int selectedIndex) {
          [gridCell deselectAnimated:YES];
        };
      }
      [gridCell prepareForTableView:tableView indexPath:indexPath];
      gridCell.numberOfElements = 3;
      [gridCell setText:@"One" atIndex:0];
      [gridCell setDetailText:@"Detail Text" atIndex:0];
      [gridCell setText:@"Two" atIndex:1];
      [gridCell setDetailText:@"Detail Text" atIndex:1];
      [gridCell setText:@"Three" atIndex:2];
      [gridCell setDetailText:@"Detail Text" atIndex:2];
      return gridCell;
    case 4:
      gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
      if (gridCell == nil) {
        gridCell = [[[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GridCellIdentifier] autorelease];
        gridCell.tableViewBackgroundColor = tableView.backgroundColor;
        gridCell.actionBlock = ^(NSIndexPath *indexPath, int selectedIndex) {
          [gridCell deselectAnimated:YES];
        };
      }
      [gridCell prepareForTableView:tableView indexPath:indexPath];
      gridCell.numberOfElements = 2;
      [gridCell setText:@"Four" atIndex:0];
      [gridCell setText:@"Five" atIndex:1];
      return gridCell;

    default:
      break;
  }

  // Configure the cell...
  [cell prepareForTableView:tableView indexPath:indexPath];
  cell.textLabel.text = @"Text";
  if (indexPath.section == 0) {
    cell.cornerRadius = 20;
  }
  else {
    cell.cornerRadius = 10;
  }

  return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

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
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
