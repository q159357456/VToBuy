//
//  ImageCutoutViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/1.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YKCutPhotoDelegate <NSObject>

- (void)getBackCutPhotos:(NSData *)data;

@end
@interface ImageCutoutViewController : UIViewController
@property (nonatomic, weak) id<YKCutPhotoDelegate>delegate;   // 返回全部切好的image数组
@property(nonatomic,strong)UIImage *cutImage;
@end
