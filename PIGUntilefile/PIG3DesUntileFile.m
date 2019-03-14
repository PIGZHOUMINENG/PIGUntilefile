//
//  PIG3DesUntileFile.m
//  IOSDemo
//
//  Created by CCBLifeCarblet on 2019/3/5.
//  Copyright © 2019年 CCBLifeCarblet. All rights reserved.
//

#import "PIG3DesUntileFile.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation PIG3DesUntileFile
//64 编码
static NSString * base64_encode_data(NSData*data){
    data = [data base64EncodedDataWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSString * ret = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

//64 解码
static NSData * base64_decode(NSString*base64String){ //base64String 为 base64 字符串
    NSData * data = [[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    return data;
}


/**
 * 加密
 * @param context 加密的内容
 * @param key 秘钥
 */
+(NSString*)ThreeDESEncrypt:(NSString * )context key:(NSString*)key
{
    return base64_encode_data([self opention:context key:key  type:kCCEncrypt]);
}


/**
 * 解密
 * @param context 解密的内容
 * @param key 秘钥
 */
+(NSData*)ThreeDESDecrypt:(NSString * )context key:(NSString*)key
{
    NSData * data =  base64_decode(context);
    
    context = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return  [self opention:context key:key  type:kCCDecrypt];
}


+(NSData * )opention:(NSString * )context key:(NSString*)key  type:(uint32_t)type {
    
    NSData * data = [context dataUsingEncoding:NSUTF8StringEncoding];
    
    void *  keyPtr = (void *)[key UTF8String];
   
    
    size_t outSize = (data.length+kCCKeySize3DES) & ~(kCCKeySize3DES -1);
    
    void * DataOut = malloc(outSize * sizeof(uint8_t));
    
    
    // kCCEncrypt 加密
    CCCryptorStatus status =  CCCrypt(type,
                                      kCCAlgorithm3DES,
                                      kCCOptionECBMode|kCCOptionPKCS7Padding,
                                      keyPtr,
                                      sizeof(keyPtr),
                                      nil,
                                      data.bytes,
                                      data.length,
                                      DataOut,
                                      outSize,0);
    if (status==kCCSuccess) {
        return [NSData dataWithBytesNoCopy:DataOut length:outSize];
    }
    free(DataOut);
    return nil;
}
@end
