﻿#ifdef SM4

// Macros for targetting shader model 4.0 (DX11)
#define TECHNIQUE(name, vsname, psname ) \
	technique name { pass { VertexShader = compile vs_4_0_level_9_1 vsname (); PixelShader = compile ps_4_0_level_9_1 psname(); } }
#define DECLARE_TEXTURE(Name, index) \
    Texture2D<float4> Name : register(t##index); \
    sampler Name##Sampler : register(s##index)
#define SAMPLE_TEXTURE(Name, texCoord)  Name.Sample(Name##Sampler, texCoord)

#else

// Macros for targetting shader model 2.0 (DX9)
#define TECHNIQUE(name, vsname, psname ) \
	technique name { pass { VertexShader = compile vs_2_0 vsname (); PixelShader = compile ps_2_0 psname(); } }
#define DECLARE_TEXTURE(Name, index) \
    sampler2D Name : register(s##index);
#define SAMPLE_TEXTURE(Name, texCoord)  tex2D(Name, texCoord)

#endif

// Camera settings.
float4 World;
float4x4 View;
float4x4 Projection;


// This sample uses a simple Lambert lighting model.
float3 LightDirection = normalize(float3(-1, -1, -1));
float3 DiffuseLight = 1.25;
float3 AmbientLight = 0.25;


struct InstanceData
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
};

struct BlockData
{
    float4 Color : COLOR0;
    float4 Offset : POSITION1;
};


struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float4 Color : COLOR0;
};


VertexShaderOutput DebugVS(InstanceData unitCube, BlockData blockData)
{
    VertexShaderOutput output;

    float4 worldPosition = World + unitCube.Position + blockData.Offset;
    float4 viewPosition = mul(worldPosition, View);

    output.Position = mul(viewPosition, Projection);
    output.Color = blockData.Color;

    return output;
}

VertexShaderOutput InstancingVS(InstanceData unitCube, BlockData blockData)
{
    VertexShaderOutput output;

    // Apply the world and camera matrices to compute the output position.
    float4 worldPosition = World + unitCube.Position + blockData.Offset;
    float4 viewPosition = mul(worldPosition, View);
    output.Position = mul(viewPosition, Projection);

    // Compute lighting, using a simple Lambert model.
    float3 worldNormal = unitCube.Normal;
    float diffuseAmount = max(-dot(worldNormal, LightDirection), 0);
    float3 lightingResult = saturate(diffuseAmount * DiffuseLight + AmbientLight);
    
    output.Color = float4(lightingResult, 1) * blockData.Color;

    return output;
}

float4 InstancingPS(VertexShaderOutput input) : COLOR0
{
    return input.Color;
}

// Hardware instancing technique.
TECHNIQUE(Debug, DebugVS, InstancingPS);
TECHNIQUE(Instancing, InstancingVS, InstancingPS);