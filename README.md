---
services:
platforms:
author: azure
---

MobileServices-iOS-Client
=========================

This client demonstrates connecting an iOS client to Windows Azure Mobile Services.



# Mobile Services - The iOS Client
This is an iOS application which demonstrates how to connect to [Windows Azure Mobile Services](https://www.windowsazure.com/en-us/develop/mobile/).  The client has a dependency on setting up a Mobile Service in the Windows Azure portal.  The application allows users to view a list of todo items, mark them as complete, and add new ones.  This sample was built using XCode and the iOS Framework.

Below you will find requirements and deployment instructions.

## Requirements
* OSX - This sample was built on OSX Lion (10.7.4) but should work with more current releases of OSX.
* XCode - This sample was built with XCode 4.4 and requires at least XCode 4.0 due to use of storyboards and ARC.
* Windows Azure Account - Needed to request access to, and create, Mobile Services.  [Sign up for a free trial](https://www.windowsazure.com/en-us/pricing/free-trial/).

## Additional Resources
Click the links below for more information on the technologies used in this sample.
* Blog Post - [Mobile Services and iOS](http://chrisrisner.com/Windows-Azure-Mobile-Services-and-iOS).

#Specifying your mobile service's subdomain and App ID
Once you've set up your Mobile Service in the Windows Azure portal, you will need to enter your site's subdomain into the source/mymobileservice/Constants.m file.  Replace all of the your-subdomain with the subdomain of the site you set up.

    NSString *kGetAllUrl = @"https://yoursubdomain.azure-mobile.net/tables/TodoItem?$filter=(complete%20eq%20false)";
    NSString *kAddUrl = @"https://yoursubdomain.azure-mobile.net/tables/TodoItem";
    NSString *kUpdateUrl = @"https://yoursubdomain.azure-mobile.net/tables/TodoItem/";

Finally, copy the APP ID from the portal into the constants.m file:

    NSString *kMobileServiceAppId = @"yourappid";

## Contact

For additional questions or feedback, please contact the [team](mailto:chrisner@microsoft.com).