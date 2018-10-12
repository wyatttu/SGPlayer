//
//  SGFFDefinesMapping.h
//  SGPlayer
//
//  Created by Single on 2018/1/26.
//  Copyright © 2018年 single. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGGLTextureUploader.h"
#import "SGGLViewport.h"
#import "SGGLProgram.h"
#import "SGFFDefines.h"
#import "SGDefines.h"
#import "SGGLModel.h"
#import "libavutil/samplefmt.h"
#import "libavutil/pixfmt.h"

// SG -> GL
SGGLModelType SGDMDisplay2Model(SGDisplayMode displayMode);
SGGLProgramType SGDMFormat2Program(SGAVPixelFormat format);
SGGLTextureType SGDMFormat2Texture(SGAVPixelFormat format);
SGGLViewportMode SGDMScaling2Viewport(SGScalingMode scalingMode);

// FF -> SG
SGMediaType SGDMMediaTypeFF2SG(enum AVMediaTypeX mediaType);
SGAVSampleFormat SGDMSampleFormatFF2SG(enum AVSampleFormat format);
SGAVPixelFormat SGDMPixelFormatFF2SG(enum AVPixelFormat format);
SGAVColorPrimaries SGDMColorPrimariesFF2SG(enum AVColorPrimaries format);
SGAVColorTransferCharacteristic SGDMColorTransferCharacteristicFF2SG(enum AVColorTransferCharacteristic format);
SGAVColorSpace SGDMColorSpaceFF2SG(enum AVColorSpace format);
SGAVColorRange SGDMColorRangeFF2SG(enum AVColorRange format);
SGAVChromaLocation SGDMChromaLocationFF2SG(enum AVChromaLocation format);

// SG -> FF
enum AVMediaTypeX SGDMMediaTypeSG2FF(SGMediaType mediaType);
enum AVSampleFormat SGDMSampleFormatSG2FF(SGAVSampleFormat foramt);
enum AVPixelFormat SGDMPixelFormatSG2FF(SGAVPixelFormat foramt);
enum AVColorPrimaries SGDMColorPrimariesSG2FF(SGAVColorPrimaries foramt);
enum AVColorTransferCharacteristic SGDMColorTransferCharacteristicSG2FF(SGAVColorTransferCharacteristic foramt);
enum AVColorSpace SGDMColorSpaceSG2FF(SGAVColorSpace foramt);
enum AVColorRange SGDMColorRangeSG2FF(SGAVColorRange foramt);
enum AVChromaLocation SGDMChromaLocationSG2FF(SGAVChromaLocation foramt);

// SG <-> AV
OSType SGDMPixelFormatSG2AV(SGAVPixelFormat format);
SGAVPixelFormat SGDMPixelFormatAV2SG(OSType format);
