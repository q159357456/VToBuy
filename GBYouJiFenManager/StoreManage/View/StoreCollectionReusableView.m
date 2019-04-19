//
//  StoreCollectionReusableView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StoreCollectionReusableView.h"
#import "AfivchModel.h"
@interface StoreCollectionReusableView()
@property (nonatomic, strong) GYChangeTextView *tView;


@end
@implementation StoreCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {

        self.backgroundColor=[ColorTool colorWithHexString:@"#fef6e1"];
        
    }
    return self;
    
}
-(void)setTitileArray:(NSMutableArray *)titileArray
{
    _titileArray=titileArray;

    if (_titileArray.count) {
        if ([self.subviews containsObject:_tView]) {
            [_tView removeFromSuperview];
           
            _tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(30, 0,screen_width-26-25, 35)];
            _tView.delegate=self;
            [self addSubview:_tView];
            _tView.textLabel.textColor=[UIColor lightGrayColor];
            _tView.textLabel.font=[UIFont systemFontOfSize:13];
            _tView.textLabel.textAlignment=NSTextAlignmentLeft;
        }else
        {
            _tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(30, 0,screen_width-26-25, 35)];
            _tView.delegate=self;
            [self addSubview:_tView];
            _tView.textLabel.textColor=[UIColor lightGrayColor];
            _tView.textLabel.font=[UIFont systemFontOfSize:13];
            _tView.textLabel.textAlignment=NSTextAlignmentLeft;

        }
        
   

        NSMutableArray *array=[NSMutableArray array];
        for (AfivchModel *model in _titileArray)
        {
             
            [array addObject:model.Title];
        }
   
        [_tView animationWithTexts:array];
        
    }

}
- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    self.tapClick(index);
}


@end
