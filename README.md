# YelpRBC

1. Requirements:
a.	Yelp Reviews App –  (Due date: Friday, February 26, 9 AM)
b.	Build an iOS app of a scrolling grid of 10 restaurants and latest review where you can search, sort, and tap to view more details (whatever details you feel are important with the latest 10 photos posted from users).  For this challenge, you will use Yelp's API (https://www.yelp.com/developers) that match the search "Ethiopian".  Try to make it look visually appealing, use the latest version of Xcode and deliver your project in a .zip file or GitHub or bit bucket.  If you want to send a zip file, send it to my personal email farleycaesar@me.com  as RBC does not allow source code in emails.
c.	Target iPhones running iOS version 9.2 or above. If you also want to support iPads, you can but it is not a requirement.
d.	Ideally all orientations, but feel free to only support portrait. 
e.	That is up to you. Use whatever approach you believe offers a good user experience.

2. Classes:
Created by Jerry Li:
a.YelpRBCSearchViewController.h + YelpRBCSearchViewController.m (root view)
b.YRSearchStoreView. h + YRSearchStoreView. m
c.YRSingleStoreViewController. h + YRSingleStoreViewController. m
d. YRReviewView. h + YRReviewView. h 
e. YRImageView.h + YRImageView.m
f. YRSearchManager.h + YRSearchManager.m
g. AppDelegate.h + AppDelegate.m

Downloaded from internet and Yelp’s sample code for OAuth 1.0a and modified by Jerry Li
a. OMGFormURLEncode.h + OMGFormURLEncode.m
b. OMGHTTPURLRQ.h + OMGHTTPURLRQ.m
c. OMGUserAgent.h + OMGUserAgent.m
d. TDOAuth.h + TDOAuth.m
e. NSURLRequest+OAuth.h + NSURLRequest+OAuth.m

Unit Test file:
a. YRSearchManagerTest.m

3. The app target to iPhones with iOS 9.2 or later.  It is tested in the simulators of iPhone 5s, iPhone 6, iPhone 6 plus, iPhone 6s and iPhone 6s plus. When locations service is enabled,  the default location is current location. When location service is disabled, the default location is “Toronto”. The default setting for term is “Cafe”. 

4. Google map API is also used for location service because yelp API doesn’t support location latitude, longitude parameter very well.

5. Because Yelp API only return one review and one image for each store, the review and the image is duplicated used 10 times to show the scrolling effect in the view of the store details.


