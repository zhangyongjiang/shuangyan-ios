//
//  FileReferenceHeader.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/24.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#ifndef FileReferenceHeader_h
#define FileReferenceHeader_h

#define VariableName(arg) (@""#arg)

#define FullWidth ([UIView screenWidth])
#define PagePadding  (10*[UIView scale])
#define FullWidthExcludePadding   ([UIView screenWidth]-PagePadding*2)
#define HalfWidthExcludePadding2   (([UIView screenWidth]-PagePadding*2)/2)
#define HalfWidthExcludePadding3   (([UIView screenWidth]-PagePadding*3)/2)
#define FormFieldHeight (45*[UIView scale])
#define LabelLineHeight 44
#define SectionSpacing  (25*[UIView scale])

#define ButtonHeightLarge (40*[UIView scale])
#define ButtonHeightSmall (30*[UIView scale])

#define NotificationRefreshControl      @"NotificationRefreshControl"
#define NotificationEndOfDisplay        @"NotificationEndOfDisplay"
#define NotificationPushController      @"NotificationPushController"
#define NotificationPresentController   @"NotificationPresentController"
#define NotificationNewReview           @"NotificationNewReview"
#define NotificationLogout              @"NotificationLogout"
#define NotificationNoGuest             @"NotificationNoGuest"
#define NotificationAlert               @"NotificationAlert"
#define NotificationMeChanged           @"NotificationMeChanged"
#define NotificationCartChanged         @"NotificationCartChanged"
#define NotificationMsgChanged          @"NotificationMsgChanged"
#define NotificationLangChanged         @"NotificationLangChanged"
#define NotificationTextFieldFocused    @"NotificationTextFieldFocused"
#define NotificationProductChanged      @"NotificationProductChanged"
#define NotificationBackgroundImage     @"NotificationBackgroundImage"
#define NotificationEditing             @"NotificationEditing"
#define NotificationLabelTabChanged     @"NotificationLabelTabChanged"

#define EventCollectionViewLongPress    @"EventCollectionViewLongPress"

#define FontMedium  @"GothamRounded-Medium"
#define FontBook    @"GothamRounded-Book"

#define PageSize 20

#define CornerRadius 5*[UIView scale]
#define FormBorderColor [UIColor colorFromRGB:0xc8c7cc]
#define FormBorderWidth 1
#define FormTopMargin   (68*[UIView scale])
#define FormFieldMargin 1
#define ViewMargin 25

#define TextViewPlaceHolder @"Your review"

#endif /* FileReferenceHeader_h */
