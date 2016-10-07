/*
 Copyright 2016 OpenMarket Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MXCryptoAlgorithms.h"

#import "MXOlm.h"

#pragma mark - Constants definitions
NSString *const kMXCryptoOlmAlgorithm = @"m.olm.v1.curve25519-aes-sha2";
NSString *const kMXCryptoMegolmAlgorithm = @"m.megolm.v1.aes-sha2";


@interface MXCryptoAlgorithms ()
{
    NSMutableDictionary<NSString*, Class<MXEncrypting>> *encryptors;
    NSMutableDictionary<NSString*, Class<MXDecrypting>> *decryptors;
}

@end

static MXCryptoAlgorithms *sharedOnceInstance = nil;

@implementation MXCryptoAlgorithms

+ (instancetype)sharedAlgorithms
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOnceInstance = [[self alloc] init];
    });
    return sharedOnceInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        encryptors = [NSMutableDictionary dictionary];
        decryptors = [NSMutableDictionary dictionary];

        // Register default cryptos
        [self registerAlgorithm:kMXCryptoOlmAlgorithm encryptorClass:nil decryptorClass:nil];
        [self registerAlgorithm:kMXCryptoMegolmAlgorithm encryptorClass:nil decryptorClass:nil];
    }
    return self;
}

- (void)registerAlgorithm:(NSString *)algorithm encryptorClass:(Class<MXEncrypting>)encryptorClass decryptorClass:(Class<MXDecrypting>)decryptorClass
{
    encryptors[algorithm] = encryptorClass;
    decryptors[algorithm] = decryptorClass;
}

- (Class<MXEncrypting>)encryptorClassForAlgorithm:(NSString *)algorithm
{
    return encryptors[algorithm];
}

- (Class<MXDecrypting>)decryptorClassForAlgorithm:(NSString *)algorithm
{
    return decryptors[algorithm];
}

- (NSArray<NSString *> *)supportedAlgorithms
{
    return encryptors.allKeys;
}

@end

