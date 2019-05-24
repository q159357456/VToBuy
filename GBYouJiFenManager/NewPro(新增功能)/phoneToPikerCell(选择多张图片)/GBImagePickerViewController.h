//
//  GBImagePickerViewController.h
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/5/24.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoImage.h"
#import "myPhotoCell.h"
#import "UIImage+fixOrientation.h"
#import "WPFunctionView.h"
#import "NavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GBImagePickerViewController : UIViewController
@property (assign, nonatomic) NSInteger selectPhotoOfMax;/**< 选择照片的最多张数 */

/** 回调方法 */
@property (nonatomic, copy) void(^selectPhotosBack)(NSMutableArray *photosArr);
@end

NS_ASSUME_NONNULL_END
