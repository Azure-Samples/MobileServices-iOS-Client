// ----------------------------------------------------------------------------------
// Microsoft Developer & Platform Evangelism
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// ----------------------------------------------------------------------------------
// The example companies, organizations, products, domain names,
// e-mail addresses, logos, people, places, and events depicted
// herein are fictitious.  No association with any real company,
// organization, product, domain name, email address, logo, person,
// places, or events is intended or should be inferred.
// ----------------------------------------------------------------------------------

#import "ViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "TodoDetailsViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadTodos];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) loadTodos {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
         requestWithURL:
         [NSURL URLWithString: kGetAllUrl]
         cachePolicy:NSURLRequestUseProtocolCachePolicy
         timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"GET"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"ACCEPT"];
    [theRequest addValue:kMobileServiceAppId forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data];
    } else {
        // We should inform the user that the connection failed.
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.todos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSLog( @"Indexpath %i", [ indexPath row ] );
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [[appDelegate.todos objectAtIndex:[indexPath row]] objectForKey:@"text"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response {
    if (receivedData == NULL) {
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData setLength:0];
    NSLog(@"didReceiveResponse: responseData length:(%d)", receivedData.length);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:receivedData
                     options:kNilOptions
                     error:&error];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.todos = json;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewExistingTodo"])
	{
        TodoDetailsViewController *todoDetailsViewController = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        todoDetailsViewController.todoText = cell.textLabel.text;
        todoDetailsViewController.delegate = self;
        todoDetailsViewController.addingNewTodo = NO;
	} else if ([segue.identifier isEqualToString:@"addNewTodo"]) {
        TodoDetailsViewController *todoDetailsViewController = segue.destinationViewController;
        todoDetailsViewController.delegate = self;
        todoDetailsViewController.addingNewTodo = YES;
    }
}

#pragma TodoDetailsViewControllerDelegate
- (void)todoDetailsViewController:(TodoDetailsViewController *)controller didFinishWithTodo:(NSString *)todoId andTodoText:(NSString *)todoText {
    [self loadTodos];
}

@end
