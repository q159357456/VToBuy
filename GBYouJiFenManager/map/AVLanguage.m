//
//  AVLanguage.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AVLanguage.h"
@interface AVLanguage()<AVSpeechSynthesizerDelegate>
{
    
        
        AVSpeechSynthesizer* av;
        
        
    
}
@end
@implementation AVLanguage
-(void)startVoiceWithStr:(NSString *)str
{
    //初始化对象
    
    av= [[AVSpeechSynthesizer alloc]init];
    
    av.delegate=self;//挂上代理
    
    AVSpeechUtterance*utterance = [AVSpeechUtterance speechUtteranceWithString:str];//需要转换的文字
    
    utterance.rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
    
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，这是中文普通话
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    utterance.voice= voice;
    
    [av speakUtterance:utterance];//开始
    


}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}

@end
