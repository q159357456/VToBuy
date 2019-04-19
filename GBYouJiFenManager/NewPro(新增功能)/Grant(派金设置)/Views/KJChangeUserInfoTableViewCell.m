//
//  KJChangeUserInfoTableViewCell.m
//  XGB
//
//  Created by Yonger on 2017/8/25.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJChangeUserInfoTableViewCell.h"

@interface KJChangeUserInfoTableViewCell ()<UITextFieldDelegate,QMUITextFieldDelegate>

@property (nonatomic,strong)sureInputContent sureBlcok;

@end
@implementation KJChangeUserInfoTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _midDistance = 0;
        _isWidTitle = NO;
        [self createView];
    }
    return self;
}


- (void)createView{
    
    _view = [[UIView alloc]init];
    _view.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    /*_view.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);*/
    
    //_view.hidden = YES;
    
    self.contentTex = [[QMUITextField alloc]init];
    self.contentTex.delegate = self;
    self.contentTex.font = ZWHFont(14);
    self.contentTex.textColor = [UIColor qmui_colorWithHexString:@"292929"];
    self.contentTex.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentTex];
    [self.contentTex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(8));
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(8));
        make.centerY.equalTo(self.contentView);
    }];
    /*self.contentTex.sd_layout
    .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
    .rightSpaceToView(self.contentView,HEIGHT_PRO(10))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_PRO(30));*/
    
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"right_t"];
    self.rightImage.hidden = YES;
    [self.contentView addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(8));
        make.width.height.mas_equalTo(WIDTH_PRO(17.5));
        make.centerY.equalTo(self.contentView);
    }];
    /*self.rightImage.sd_layout
    .rightSpaceToView(self.contentView,WIDTH_PRO(15))
    .centerYEqualToView(self.contentTex)
    .widthIs(WIDTH_PRO(17.5))
    .heightIs(WIDTH_PRO(17.5));*/
    
    _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbtn.backgroundColor = [UIColor clearColor];
    _rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_rightbtn];
    [_rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_rightImage);
    }];
    /*_rightbtn.sd_layout
    .rightEqualToView(_rightImage)
    .leftEqualToView(_rightImage)
    .topEqualToView(_rightImage)
    .bottomEqualToView(_rightImage);*/
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_sureBlcok){
        _sureBlcok(self.contentTex.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_sureBlcok){
        _sureBlcok(self.contentTex.text);
    }
    [self endEditing:YES];
    return NO;
}
// ***** 显示右边的图片 *****//
-(void)showRightImage:(BOOL)show{
    self.rightImage.hidden = !show;
    if (show == YES) {
        [self.contentTex mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(WIDTH_PRO(8));
            make.right.equalTo(self.contentView).offset(-WIDTH_PRO(30));
            make.centerY.equalTo(self.contentView);
        }];
        [self.contentTex updateConstraints];
        /*self.contentTex.sd_layout
        .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
        .rightSpaceToView(self.rightImage,HEIGHT_PRO(11))
        .centerYEqualToView(self.contentView)
        .heightIs(HEIGHT_PRO(30));
        [self.contentTex updateLayout];*/
    }else{
        [self.contentTex mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(WIDTH_PRO(8));
            make.right.equalTo(self.contentView).offset(-WIDTH_PRO(8));
            make.centerY.equalTo(self.contentView);
        }];
        [self.contentTex updateConstraints];
        /*self.contentTex.sd_layout
        .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
        .rightSpaceToView(self.contentView,HEIGHT_PRO(15))
        .centerYEqualToView(self.contentView)
        .heightIs(HEIGHT_PRO(30));
        [self.contentTex updateLayout];*/
    }
    
}

-(void)didEndInput:(sureInputContent)input{
    _sureBlcok = input;
}

-(void)setLeftTitleStr:(NSString *)leftTitleStr{
    _leftTitleStr = leftTitleStr;
    if(leftTitleStr.length == 0){
        self.contentTex.leftView = nil;
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName:ZWHFont(14)};
    CGFloat length = [leftTitleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    
    if (_isWidTitle) {
        _leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_PRO(90), HEIGHT_PRO(30))];
        _leftLable.textAlignment = NSTextAlignmentCenter;
    }else{
        _leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, length+_midDistance, HEIGHT_PRO(30))];
    }
    
    //[_leftLable textFont:16 textColor:[ZSColor hexStringToColor:@"292929"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _leftLable.font = ZWHFont(14);
    _leftLable.textColor = [UIColor blackColor];
    _leftLable.backgroundColor = [UIColor clearColor];
    _leftLable.text = leftTitleStr;
    _leftLable.qmui_borderColor = LINECOLOR;
    _leftLable.qmui_borderWidth = 1;
    _leftLable.qmui_borderPosition = QMUIViewBorderPositionRight;
    self.contentTex.leftView = _leftLable;
    self.contentTex.leftViewMode = UITextFieldViewModeAlways;
    [self.contentTex layoutIfNeeded];
    //[self.contentTex updateLayout];
}

-(void)setRightTitleStr:(NSString *)rightTitleStr{
    _rightTitleStr = rightTitleStr;
    if(_rightTitleStr.length == 0){
        self.contentTex.leftView = nil;
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName:ZWHFont(14)};
    CGFloat length = [_rightTitleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    
    _rightLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, length+_midDistance, HEIGHT_PRO(30))];
    
    //[_leftLable textFont:16 textColor:[ZSColor hexStringToColor:@"292929"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _rightLable.font = ZWHFont(14);
    _rightLable.textColor = [UIColor blackColor];
    _rightLable.backgroundColor = [UIColor clearColor];
    _rightLable.text = _rightTitleStr;
    self.contentTex.rightView = _rightLable;
    self.contentTex.rightViewMode = UITextFieldViewModeAlways;
    [self.contentTex layoutIfNeeded];
    //[self.contentTex updateLayout];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.contentTex && self.maxLenght>0){
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.maxLenght) {
            return NO;
        }
    }else{
        if(((string.intValue<0) || (string.intValue>9))){
            //MyLog(@"====%@",string);
            if ((![string isEqualToString:@"."])) {
                return NO;
            }
            return NO;
        }
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger dotNum = 0;
        NSInteger flag=0;
        const NSInteger limited = 2;
        if((int)futureString.length>=1){
            
            if([futureString characterAtIndex:0] == '.'){//the first character can't be '.'
                return NO;
            }
            if((int)futureString.length>=2){//if the first character is '0',the next one must be '.'
                if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                    return NO;
                }
            }
        }
        NSInteger dotAfter = 0;
        for (int i = (int)futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                dotNum ++;
                dotAfter = flag+1;
                if (flag > limited) {
                    return NO;
                }
                if(dotNum>1){
                    return NO;
                }
            }
            flag++;
        }
        if(futureString.length - dotAfter > 10){
            return NO;
        }
        return YES;
    }
    return YES;
}


@end
