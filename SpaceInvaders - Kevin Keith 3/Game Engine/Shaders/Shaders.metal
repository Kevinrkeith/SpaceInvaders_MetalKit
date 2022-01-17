//
//  TextureLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//

#include <metal_stdlib>
using namespace metal;
struct BasicFragOutput{
    half4 color [[color(0)]];
    half4 mask [[color(1)]];
};
struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinate [[ attribute(2) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinate;
    float3 maskColor;
};

struct ModelConstants{
    float4x4 modelMatrix;
    float3 maskColor;
};

struct ScreenConstants {
    float4x4 projectionMatrix;
};
struct Material {
    float4 color;
    bool useMaterialColor;
    bool useTexture;
};


constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];
constant half4 transparency = half4(0.2126, 0.7152, 0.0722, 0);

vertex RasterizerData basic_vertex_shader(const VertexIn vIn [[ stage_in ]],
                                          constant ScreenConstants &screenConstants [[ buffer(1) ]],
                                          constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    rd.position = screenConstants.projectionMatrix * screenConstants.projectionMatrix * modelConstants.modelMatrix * float4(vIn.position, 1);
    rd.color = vIn.color;
    rd.maskColor = modelConstants.maskColor;
    rd.textureCoordinate = vIn.textureCoordinate;
    
    return rd;
}

fragment BasicFragOutput basic_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     sampler sample [[ sampler(0) ]],
                                     texture2d<float> texture [[ texture(0) ]] ){
    BasicFragOutput fragOutput;
    float2 texCoord = rd.textureCoordinate;
    
    float4 color;
    if(material.useTexture){
        color = texture.sample(sample, texCoord);
    }else if(material.useMaterialColor) {
        color = material.color;
    }else{
        color = rd.color;
    }
    if(color.a<0.01){
        discard_fragment();
    }
    fragOutput.color = half4(color);
    fragOutput.mask = half4(rd.maskColor.r,rd.maskColor.g, rd.maskColor.b,1);
    return fragOutput;
}

fragment half4 mask_fragment_shader(RasterizerData rd [[stage_in]],
                                    texture2d<float> texture [[texture(0)]]){
    
    sampler s;
    float4 color = texture.sample(s, rd.textureCoordinate);
    if(color.a<0.01){
        discard_fragment();
    }
    return half4(rd.maskColor.r, rd.maskColor.g, rd.maskColor.b, 1);
}

fragment half4 final_fragment_shader(RasterizerData rd [[stage_in]],
                                     texture2d<float> texture [[texture(0)]]){
    
    sampler s;
    float4 color = texture.sample(s, rd.textureCoordinate);
    
    return half4(color);
}

vertex RasterizerData final_vertex_shader(const VertexIn vIn[[ stage_in ]]){
    
    RasterizerData rd;
    
    rd.position = float4(vIn.position,1);
    
    rd.textureCoordinate = vIn.textureCoordinate;
    
    return rd;
}

// This turns off whatever the current Alpha is, allowing for transparency in the texture
//Based off of the Apple Documentation "Hello Compute"


// Transparency compute shader
kernel void Transparency(texture2d<half, access::read>  baseTerrain   [[ texture(0) ]],
                         texture2d<half, access::read>  missile    [[texture(1)]],
                         texture2d<half, access::write> destroyedTerrain  [[ texture(2) ]],
                         uint2                          gid         [[ thread_position_in_grid ]])
{
    if((gid.x < baseTerrain.get_width()) && (gid.y < baseTerrain.get_height()))
    {
        half4 terrainColor  = baseTerrain.read(gid);
        half4 missileColor = missile.read(gid);
        if(terrainColor.a >0.5 && missileColor.a>0.5){
            destroyedTerrain.write(half4(0,0,0,0), gid);
        }else {
            destroyedTerrain.write(half4(1,1,0,1),gid);
        }
    }
}
