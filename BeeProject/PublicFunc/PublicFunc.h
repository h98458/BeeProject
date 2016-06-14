//
//  PublicTool.h
//  Voiceprint
//
//  Created by huangrg on 14-10-15.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_2G= 3,
}NETWORK_TYPE;

@interface PublicFunc : NSObject
{
    NSArray *dayStr;    //格式化时间 时间类型数组
    NSArray *dayDHMS;   //格式化时间 d:h:m:s
    int flsg[4];        //格式化时间
}
+(PublicFunc*)getInstance;

//返回size的中心点
CGPoint uiFromSize(CGSize s);
//以A点的基准,按B点的比率返回一个新点
CGPoint uiCompMult(CGPoint a, CGPoint b);

//时间转换为天/时/分/秒中的 digit 个 ,优先级从“天”依次降低
-(NSString *)convertTimeOfDHMS:(int) secs digit:(int)digit;
//判断是否是iphone5
-(BOOL)isIPhone5RetinaDisplay;
//数字加千位分隔符,两位小数点,不够的补0
-(NSString *)setTTFWithNum:(double)num;
//UIImage 图片处理 灰度 反色 深棕色
-(UIImage*) grayscale:(UIImage*)anImage type:(char)type;
//根据两个经纬度计算距离
-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

#pragma mark - NSDate
//转化任意日期到当前时区
-(NSDate *)convertDateToLocalTime: (NSDate *)forDate;
//日期转时间时间戳
-(NSString *)convertDataToInterval:(NSDate *)date;
//时间戳转为时间格式的字符串
-(NSString *)sectionStrByCreateTime:(NSTimeInterval)interval Format:(NSString *)format;
//把字符串转换成NSDate
-(NSDate *)NSStringDateToNSDate:(NSString *)string;
//获取本时区时间
-(NSDate *)localeDateTime;

#pragma mark -  正则表达式
//检测用户名格式
-(BOOL)bLoginName:(NSString*)str;
//用户名长度应为6－20个字符
-(BOOL)bNameLength:(NSString*)str;
//检测密码格式
-(BOOL)bPassWord:(NSString*)str;
//检测邮箱地址格式
-(BOOL)isEmailAddress:(NSString*)email;
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum;
//身份证号格式
- (BOOL) isIdCard: (NSString *)identityCard;
//验证码加空格（声密保）
- (NSString *) codeAddSpace: (NSString *)code;
//手机号加*
- (NSString *) mobileAddStar: (NSString *)mobile;
//身份证号加*
- (NSString *) identityCardAddStar: (NSString *)identityCard;

#pragma mark -  程序目录及路径操作
//获取程序的Home目录
-(NSString *)getHomePath;
//获取Document目录
-(NSString *)getDocumentPath;
//获取Cache目录
-(NSString *)getCachePath;
//返回缓存文件夹大小
-(unsigned long long int)cacheFolderSize;
//清空缓存
-(void)resetCache;
//获取Library目录
-(NSString *)getLibraryPath;
//获取Tmp目录
-(NSString *)getTmpPath;

#pragma mark - 判断密码强度函数

//判断是否包含
+(BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password;
//条件
+ (int)judgePasswordStrength:(NSString*) _password;

#pragma mark -  浏览器缓存
//清除cookies
-(void)deleteUIWebViewCookie;
//UIWebView清除缓存
-(void)deleteUIWebViewCache;

#pragma mark -  随机生成字符串
//生成随机数
-(int)createRandom;
//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to;

#pragma mark - 图片
//保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withPath:(NSString *)path;
//UIImage按size缩放
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

#pragma mark - 生成二维码图片
//InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
//QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString;
//imageToTransparent
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

#pragma mark - 
-(NSString *)getUrlParameter:(NSString *)param webaddress:(NSString *)url;
@end

