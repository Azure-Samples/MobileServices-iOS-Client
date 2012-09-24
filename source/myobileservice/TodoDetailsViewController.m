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

#import "TodoDetailsViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "NSData+Base64.h"

@interface TodoDetailsViewController ()

@end

@implementation TodoDetailsViewController
@synthesize viewCreateTodo;
@synthesize viewDetailsTodo;
@synthesize txtTodoText;
@synthesize lblTodoText;
@synthesize addingNewTodo;
@synthesize todoText;
@synthesize delegate;
@synthesize imageViewNewTodo;
@synthesize imageViewExistingTodo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (addingNewTodo == NO) {
        //Viewing an existing todo
        viewCreateTodo.hidden = YES;
        lblTodoText.text = todoText;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (NSDictionary *item in appDelegate.todos) {
            if ([todoText isEqualToString:[item objectForKey:@"text"]]){
                todoId = (NSNumber*) [item objectForKey:@"id"];
                NSString *stringData = (NSString *)[item objectForKey:@"coltest"];
                if (stringData != (id)[NSNull null]) {
                    NSData *data = [NSData dataFromBase64String:stringData];
                    UIImage *image = [UIImage imageWithData:data];
                    imageViewExistingTodo.image = image;
                }
                break;
            }
        }
    } else {
        //Adding a new todo
        viewDetailsTodo.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [self setTxtTodoText:nil];
    [self setLblTodoText:nil];
    [self setViewCreateTodo:nil];
    [self setViewDetailsTodo:nil];
    [self setImageViewNewTodo:nil];
    [self setImageViewExistingTodo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)tapSaveTodo:(id)sender {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:
                                     [NSURL URLWithString:kAddUrl]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"ACCEPT"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:kMobileServiceAppId forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
    
    NSData *data = nil;
    NSString *imageData = nil;
    if (imageViewNewTodo.image != nil) {
        UIImage *image = imageViewNewTodo.image;
        data = UIImagePNGRepresentation(image);
        imageData = [data base64EncodedString];
    }

    
    //build an info object and convert to json
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"false", @"complete",
                                    txtTodoText.text, @"text",
                                    imageData, @"coltest",
                                    nil];
    //convert JSON object to data
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                           options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPBody:jsonData];
    // create the connection with the request and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // We should inform the user that the connection failed.
    }
}

#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response {
    if (receivedData == NULL) {
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData setLength:0];
    httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"Code: %i", [httpResponse statusCode]);
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
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    //A successful response will have either a 200 (for updating) or a 201 (for adding) response code
    if ([httpResponse statusCode]== 200 || [httpResponse statusCode] == 201) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate todoDetailsViewController:self didFinishWithTodo:nil andTodoText:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                        message:@"Failed to mark item completed."
                       delegate:self
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)tapMarkTodoComplete:(id)sender {
    NSURL *urlUpdate = [[ NSURL alloc ] initWithString:[kUpdateUrl stringByAppendingFormat:@"%@",todoId] ];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:urlUpdate
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"PATCH"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"ACCEPT"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:kMobileServiceAppId forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
    //build an info object and convert to json
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"true", @"complete",
                                    todoId, @"id",
                                    todoText, @"text",
                                    nil];
    //convert JSON object to data
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                               options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPBody:jsonData];
    // create the connection with the request and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // We should inform the user that the connection failed.
    }
}
- (IBAction)tapSelectImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}

#pragma UIImagePickerControllerDelegate Methods

/**
 Called when the user has selected an image from the Gallery
 */
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    imageViewNewTodo.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}
@end
