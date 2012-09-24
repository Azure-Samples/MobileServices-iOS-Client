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

#import <UIKit/UIKit.h>

@class TodoDetailsViewController;

@protocol TodoDetailsViewControllerDelegate <NSObject>
- (void)todoDetailsViewController:(TodoDetailsViewController *)controller didFinishWithTodo:(NSString *)todoId andTodoText:(NSString *)todoText;
@end

@interface TodoDetailsViewController : UIViewController<NSURLConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    @private
    NSNumber* todoId;
    NSMutableData* receivedData;
    NSHTTPURLResponse* httpResponse;
}
@property (weak, nonatomic) IBOutlet UIView *viewCreateTodo;
@property (weak, nonatomic) IBOutlet UIView *viewDetailsTodo;
@property (weak, nonatomic) IBOutlet UITextField *txtTodoText;
@property (weak, nonatomic) IBOutlet UILabel *lblTodoText;
@property (nonatomic, weak) id <TodoDetailsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNewTodo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewExistingTodo;
@property (nonatomic, weak) NSString *todoText;
@property BOOL addingNewTodo;
- (IBAction)tapSaveTodo:(id)sender;
- (IBAction)tapMarkTodoComplete:(id)sender;
- (IBAction)tapSelectImage:(id)sender;
@end
