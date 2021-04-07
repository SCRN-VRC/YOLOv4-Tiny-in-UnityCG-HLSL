Shader "YOLOv4Tiny/yolov4tiny"
{
    Properties
    {
        _CamIn ("Cam Input", 2D) = "white" {}
        _Buffer ("Buffer", 2D) = "black" {}
        _Baked ("Baked Params", 2D) = "black" {}
        _FrameDelay ("Frame Delay", Range(1, 20)) = 5
        _MaxDist ("Max Distance", Float) = 0.02
    }
    SubShader
    {
        Tags { "Queue"="Overlay+1" "ForceNoShadowCasting"="True" "IgnoreProjector"="True" }
        ZWrite Off
        ZTest Always
        Cull Off

        Pass
        {
            Lighting Off
            SeparateSpecular Off
            Fog { Mode Off }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0

            #include "UnityCG.cginc"
            #include "yolo_include.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //RWStructuredBuffer<float4> buffer : register(u1);
            sampler2D _CamIn;
            Texture2D<float> _Buffer;
            Texture2D<float> _Baked;
            float4 _Buffer_TexelSize;
            float _MaxDist;
            uint _FrameDelay;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(v.uv * 2 - 1, 0, 1);
                #ifdef UNITY_UV_STARTS_AT_TOP
                v.uv.y = 1-v.uv.y;
                #endif
                o.uv.xy = UnityStereoTransformScreenSpaceTex(v.uv);
                o.uv.z = (distance(_WorldSpaceCameraPos,
                    mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz) > _MaxDist) ?
                    -1 : 1;
                o.uv.z = unity_OrthoParams.w ? o.uv.z : -1;
                return o;
            }

            float frag (v2f i) : SV_Target
            {
                clip(i.uv.z);
                uint2 px = i.uv.xy * _Buffer_TexelSize.zw;
                
                float col = _Buffer[px];
                uint time = floor(_Time.y * 90);

                // Resize RGB channels for input
                [branch]
                if ((time % _FrameDelay) == 0 && insideArea(txImgIn0, px))
                {
                    px -= txImgIn0.xy;
                    float2 iuv = px / float2(txImgIn0.zw) - 0.5;
                    pR(iuv, 1.571);
                    iuv += 0.5;
                    col.r = tex2D(_CamIn, iuv).r;
                }
                else if ((time % _FrameDelay) == 0 && insideArea(txImgIn1, px))
                {
                    px -= txImgIn1.xy;
                    float2 iuv = px / float2(txImgIn1.zw) - 0.5;
                    pR(iuv, 1.571);
                    iuv += 0.5;
                    col.r = tex2D(_CamIn, iuv).g;
                }
                else if ((time % _FrameDelay) == 0 && insideArea(txImgIn2, px))
                {
                    px -= txImgIn2.xy;
                    float2 iuv = px / float2(txImgIn2.zw) - 0.5;
                    pR(iuv, 1.571);
                    iuv += 0.5;
                    col.r = tex2D(_CamIn, iuv).b;
                }
                else if ((time + 1) % _FrameDelay == 0 && insideArea(txL0, px))
                {
                    px -= txL0.xy;
                    uint i = px.y % 208;
                    uint j = px.x % 208;
                    uint k = (px.x / 208) + (px.y / 208) * 4;

                    uint i0 = i * 2, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j * 2, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    sum = mad(getImg(_Buffer, txImgIn0, i0, j0), getW0(_Baked, uint4(0, 0, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i0, j1), getW0(_Baked, uint4(0, 1, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i0, j2), getW0(_Baked, uint4(0, 2, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i1, j0), getW0(_Baked, uint4(1, 0, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i1, j1), getW0(_Baked, uint4(1, 1, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i1, j2), getW0(_Baked, uint4(1, 2, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i2, j0), getW0(_Baked, uint4(2, 0, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i2, j1), getW0(_Baked, uint4(2, 1, 0, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn0, i2, j2), getW0(_Baked, uint4(2, 2, 0, k)), sum);
                
                    sum = mad(getImg(_Buffer, txImgIn1, i0, j0), getW0(_Baked, uint4(0, 0, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i0, j1), getW0(_Baked, uint4(0, 1, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i0, j2), getW0(_Baked, uint4(0, 2, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i1, j0), getW0(_Baked, uint4(1, 0, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i1, j1), getW0(_Baked, uint4(1, 1, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i1, j2), getW0(_Baked, uint4(1, 2, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i2, j0), getW0(_Baked, uint4(2, 0, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i2, j1), getW0(_Baked, uint4(2, 1, 1, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn1, i2, j2), getW0(_Baked, uint4(2, 2, 1, k)), sum);

                    sum = mad(getImg(_Buffer, txImgIn2, i0, j0), getW0(_Baked, uint4(0, 0, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i0, j1), getW0(_Baked, uint4(0, 1, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i0, j2), getW0(_Baked, uint4(0, 2, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i1, j0), getW0(_Baked, uint4(1, 0, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i1, j1), getW0(_Baked, uint4(1, 1, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i1, j2), getW0(_Baked, uint4(1, 2, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i2, j0), getW0(_Baked, uint4(2, 0, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i2, j1), getW0(_Baked, uint4(2, 1, 2, k)), sum);
                    sum = mad(getImg(_Buffer, txImgIn2, i2, j2), getW0(_Baked, uint4(2, 2, 2, k)), sum);

                    // sum += getImg(_Buffer, txImgIn0, i0, j0) * getW0(_Baked, uint4(0, 0, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i0, j1) * getW0(_Baked, uint4(0, 1, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i0, j2) * getW0(_Baked, uint4(0, 2, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i1, j0) * getW0(_Baked, uint4(1, 0, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i1, j1) * getW0(_Baked, uint4(1, 1, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i1, j2) * getW0(_Baked, uint4(1, 2, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i2, j0) * getW0(_Baked, uint4(2, 0, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i2, j1) * getW0(_Baked, uint4(2, 1, 0, k)) +
                    //     getImg(_Buffer, txImgIn0, i2, j2) * getW0(_Baked, uint4(2, 2, 0, k));
                
                    // sum += getImg(_Buffer, txImgIn1, i0, j0) * getW0(_Baked, uint4(0, 0, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i0, j1) * getW0(_Baked, uint4(0, 1, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i0, j2) * getW0(_Baked, uint4(0, 2, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i1, j0) * getW0(_Baked, uint4(1, 0, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i1, j1) * getW0(_Baked, uint4(1, 1, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i1, j2) * getW0(_Baked, uint4(1, 2, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i2, j0) * getW0(_Baked, uint4(2, 0, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i2, j1) * getW0(_Baked, uint4(2, 1, 1, k)) +
                    //     getImg(_Buffer, txImgIn1, i2, j2) * getW0(_Baked, uint4(2, 2, 1, k));

                    // sum += getImg(_Buffer, txImgIn2, i0, j0) * getW0(_Baked, uint4(0, 0, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i0, j1) * getW0(_Baked, uint4(0, 1, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i0, j2) * getW0(_Baked, uint4(0, 2, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i1, j0) * getW0(_Baked, uint4(1, 0, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i1, j1) * getW0(_Baked, uint4(1, 1, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i1, j2) * getW0(_Baked, uint4(1, 2, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i2, j0) * getW0(_Baked, uint4(2, 0, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i2, j1) * getW0(_Baked, uint4(2, 1, 2, k)) +
                    //     getImg(_Buffer, txImgIn2, i2, j2) * getW0(_Baked, uint4(2, 2, 2, k));

                    // for (uint l = 0; l < 3; l++)
                    // {
                    //     sum += test(uint3(i0, j0, l)) * getW0(_Baked, uint4(0, 0, l, k)) +
                    //         test(uint3(i0, j1, l)) * getW0(_Baked, uint4(0, 1, l, k)) +
                    //         test(uint3(i0, j2, l)) * getW0(_Baked, uint4(0, 2, l, k)) +
                    //         test(uint3(i1, j0, l)) * getW0(_Baked, uint4(1, 0, l, k)) +
                    //         test(uint3(i1, j1, l)) * getW0(_Baked, uint4(1, 1, l, k)) +
                    //         test(uint3(i1, j2, l)) * getW0(_Baked, uint4(1, 2, l, k)) +
                    //         test(uint3(i2, j0, l)) * getW0(_Baked, uint4(2, 0, l, k)) +
                    //         test(uint3(i2, j1, l)) * getW0(_Baked, uint4(2, 1, l, k)) +
                    //         test(uint3(i2, j2, l)) * getW0(_Baked, uint4(2, 2, l, k));
                    // }

                    sum = batchNorm(sum, _Baked, txWN0, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 200 && j == 187 && k == 17) buffer[0] = col.rrrr;
                }
                else if ((time + 2) % _FrameDelay == 0 && insideArea(txL1, px))
                {
                    px -= txL1.xy;
                    uint i = px.y % 104;
                    uint j = px.x % 104;
                    uint k = (px.x / 104) + (px.y / 104) * 8;

                    uint i0 = i * 2, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j * 2, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 32; l++)
                    {
                        sum += getL0(_Buffer, uint3(i0, j0, l)) * getW1(_Baked, uint4(0, 0, l, k)) +
                            getL0(_Buffer, uint3(i0, j1, l)) * getW1(_Baked, uint4(0, 1, l, k)) +
                            getL0(_Buffer, uint3(i0, j2, l)) * getW1(_Baked, uint4(0, 2, l, k)) +
                            getL0(_Buffer, uint3(i1, j0, l)) * getW1(_Baked, uint4(1, 0, l, k)) +
                            getL0(_Buffer, uint3(i1, j1, l)) * getW1(_Baked, uint4(1, 1, l, k)) +
                            getL0(_Buffer, uint3(i1, j2, l)) * getW1(_Baked, uint4(1, 2, l, k)) +
                            getL0(_Buffer, uint3(i2, j0, l)) * getW1(_Baked, uint4(2, 0, l, k)) +
                            getL0(_Buffer, uint3(i2, j1, l)) * getW1(_Baked, uint4(2, 1, l, k)) +
                            getL0(_Buffer, uint3(i2, j2, l)) * getW1(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN1, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 100 && j == 54 && k == 21) buffer[0] = col.rrrr;
                }
                else if ((time + 3) % _FrameDelay == 0 && insideArea(txL2, px))
                {
                    px -= txL2.xy;
                    uint i = px.y % 104;
                    uint j = px.x % 104;
                    uint k = (px.x / 104) + (px.y / 104) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 64; l++)
                    {
                        sum += getL1(_Buffer, uint3(i0, j0, l)) * getW2(_Baked, uint4(0, 0, l, k)) +
                            getL1(_Buffer, uint3(i0, j1, l)) * getW2(_Baked, uint4(0, 1, l, k)) +
                            getL1(_Buffer, uint3(i0, j2, l)) * getW2(_Baked, uint4(0, 2, l, k)) +
                            getL1(_Buffer, uint3(i1, j0, l)) * getW2(_Baked, uint4(1, 0, l, k)) +
                            getL1(_Buffer, uint3(i1, j1, l)) * getW2(_Baked, uint4(1, 1, l, k)) +
                            getL1(_Buffer, uint3(i1, j2, l)) * getW2(_Baked, uint4(1, 2, l, k)) +
                            getL1(_Buffer, uint3(i2, j0, l)) * getW2(_Baked, uint4(2, 0, l, k)) +
                            getL1(_Buffer, uint3(i2, j1, l)) * getW2(_Baked, uint4(2, 1, l, k)) +
                            getL1(_Buffer, uint3(i2, j2, l)) * getW2(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN2, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 51 && j == 27 && k == 55) buffer[0] = col.rrrr;
                }
                else if ((time + 4) % _FrameDelay == 0 && insideArea(txL3, px))
                {
                    px -= txL3.xy;
                    uint i = px.y % 104;
                    uint j = px.x % 104;
                    uint k = (px.x / 104) + (px.y / 104) * 4;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 32; l++)
                    {
                        sum += getL2(_Buffer, uint3(i0, j0, l + 32)) * getW3(_Baked, uint4(0, 0, l, k)) +
                            getL2(_Buffer, uint3(i0, j1, l + 32)) * getW3(_Baked, uint4(0, 1, l, k)) +
                            getL2(_Buffer, uint3(i0, j2, l + 32)) * getW3(_Baked, uint4(0, 2, l, k)) +
                            getL2(_Buffer, uint3(i1, j0, l + 32)) * getW3(_Baked, uint4(1, 0, l, k)) +
                            getL2(_Buffer, uint3(i1, j1, l + 32)) * getW3(_Baked, uint4(1, 1, l, k)) +
                            getL2(_Buffer, uint3(i1, j2, l + 32)) * getW3(_Baked, uint4(1, 2, l, k)) +
                            getL2(_Buffer, uint3(i2, j0, l + 32)) * getW3(_Baked, uint4(2, 0, l, k)) +
                            getL2(_Buffer, uint3(i2, j1, l + 32)) * getW3(_Baked, uint4(2, 1, l, k)) +
                            getL2(_Buffer, uint3(i2, j2, l + 32)) * getW3(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN3, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 100 && j == 54 && k == 21) buffer[0] = col.rrrr;
                }
                else if ((time + 5) % _FrameDelay == 0 && insideArea(txL4, px))
                {
                    px -= txL4.xy;
                    uint i = px.y % 104;
                    uint j = px.x % 104;
                    uint k = (px.x / 104) + (px.y / 104) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 32; l++)
                    {
                        sum += getL3(_Buffer, uint3(i0, j0, l)) * getW4(_Baked, uint4(0, 0, l, k)) +
                            getL3(_Buffer, uint3(i0, j1, l)) * getW4(_Baked, uint4(0, 1, l, k)) +
                            getL3(_Buffer, uint3(i0, j2, l)) * getW4(_Baked, uint4(0, 2, l, k)) +
                            getL3(_Buffer, uint3(i1, j0, l)) * getW4(_Baked, uint4(1, 0, l, k)) +
                            getL3(_Buffer, uint3(i1, j1, l)) * getW4(_Baked, uint4(1, 1, l, k)) +
                            getL3(_Buffer, uint3(i1, j2, l)) * getW4(_Baked, uint4(1, 2, l, k)) +
                            getL3(_Buffer, uint3(i2, j0, l)) * getW4(_Baked, uint4(2, 0, l, k)) +
                            getL3(_Buffer, uint3(i2, j1, l)) * getW4(_Baked, uint4(2, 1, l, k)) +
                            getL3(_Buffer, uint3(i2, j2, l)) * getW4(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN4, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 100 && j == 101 && k == 31) buffer[0] = col.rrrr;
                }
                else if ((time + 6) % _FrameDelay == 0 && insideArea(txL5, px))
                {
                    px -= txL5.xy;
                    uint i = px.y % 104;
                    uint j = px.x % 104;
                    uint k = (px.x / 104) + (px.y / 104) * 8;

                    float sum = 0.0;
                    uint l = 0;
                    for (; l < 32; l++)
                    {
                        sum += getL4NoPad(_Buffer, uint3(i, j, l)) * getW5(_Baked, uint2(l, k));
                    }
                    for (; l < 64; l++)
                    {
                        sum += getL3NoPad(_Buffer, uint3(i, j, l - 32)) * getW5(_Baked, uint2(l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN5, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 100 && j == 101 && k == 31) buffer[0] = col.rrrr;
                }
                else if ((time + 6) % _FrameDelay == 0 && insideArea(txL5c52, px))
                {
                    px -= txL5c52.xy;
                    uint i = px.y % 52;
                    uint j = px.x % 52;
                    uint k = (px.x / 52) + (px.y / 52) * 8;
                    
                    uint i0 = i * 2, i1 = i0 + 1;
                    uint j0 = j * 2, j1 = j0 + 1;

                    float maxFlt;
                    if (k < 64)
                    {
                        maxFlt = getL2NoPad(_Buffer, uint3(i0, j0, k));
                        maxFlt = max(maxFlt, getL2NoPad(_Buffer, uint3(i0, j1, k)));
                        maxFlt = max(maxFlt, getL2NoPad(_Buffer, uint3(i1, j0, k)));
                        maxFlt = max(maxFlt, getL2NoPad(_Buffer, uint3(i1, j1, k)));
                    }
                    else
                    {
                        uint kn = k - 64;
                        maxFlt = getL5NoPad(_Buffer, uint3(i0, j0, kn));
                        maxFlt = max(maxFlt, getL5NoPad(_Buffer, uint3(i0, j1, kn)));
                        maxFlt = max(maxFlt, getL5NoPad(_Buffer, uint3(i1, j0, kn)));
                        maxFlt = max(maxFlt, getL5NoPad(_Buffer, uint3(i1, j1, kn)));
                    }

                    col.r = maxFlt;
                    //if (i == 51 && j == 20 && k == 120) {
                    //     buffer[0].r = col;
                    //     buffer[0].g = getL2NoPad(_Buffer, uint3(102, 55, 1));
                    //     buffer[0].b = getL2NoPad(_Buffer, uint3(103, 54, 1));
                    //     buffer[0].a = getL2NoPad(_Buffer, uint3(103, 55, 1));
                    //}
                }
                else if ((time + 7) % _FrameDelay == 0 && insideArea(txL6, px))
                {
                    px -= txL6.xy;
                    uint i = px.y % 52;
                    uint j = px.x % 52;
                    uint k = (px.x / 52) + (px.y / 52) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 128; l++)
                    {
                        sum += getL5c52(_Buffer, uint3(i0, j0, l)) * getW6(_Baked, uint4(0, 0, l, k)) +
                            getL5c52(_Buffer, uint3(i0, j1, l)) * getW6(_Baked, uint4(0, 1, l, k)) +
                            getL5c52(_Buffer, uint3(i0, j2, l)) * getW6(_Baked, uint4(0, 2, l, k)) +
                            getL5c52(_Buffer, uint3(i1, j0, l)) * getW6(_Baked, uint4(1, 0, l, k)) +
                            getL5c52(_Buffer, uint3(i1, j1, l)) * getW6(_Baked, uint4(1, 1, l, k)) +
                            getL5c52(_Buffer, uint3(i1, j2, l)) * getW6(_Baked, uint4(1, 2, l, k)) +
                            getL5c52(_Buffer, uint3(i2, j0, l)) * getW6(_Baked, uint4(2, 0, l, k)) +
                            getL5c52(_Buffer, uint3(i2, j1, l)) * getW6(_Baked, uint4(2, 1, l, k)) +
                            getL5c52(_Buffer, uint3(i2, j2, l)) * getW6(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN6, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 51 && j == 50 && k == 31) buffer[0] = col.rrrr;
                }
                else if ((time + 8) % _FrameDelay == 0 && insideArea(txL7, px))
                {
                    px -= txL7.xy;
                    uint i = px.y % 52;
                    uint j = px.x % 52;
                    uint k = (px.x / 52) + (px.y / 52) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 64; l++)
                    {
                        sum += getL6(_Buffer, uint3(i0, j0, l + 64)) * getW7(_Baked, uint4(0, 0, l, k)) +
                            getL6(_Buffer, uint3(i0, j1, l + 64)) * getW7(_Baked, uint4(0, 1, l, k)) +
                            getL6(_Buffer, uint3(i0, j2, l + 64)) * getW7(_Baked, uint4(0, 2, l, k)) +
                            getL6(_Buffer, uint3(i1, j0, l + 64)) * getW7(_Baked, uint4(1, 0, l, k)) +
                            getL6(_Buffer, uint3(i1, j1, l + 64)) * getW7(_Baked, uint4(1, 1, l, k)) +
                            getL6(_Buffer, uint3(i1, j2, l + 64)) * getW7(_Baked, uint4(1, 2, l, k)) +
                            getL6(_Buffer, uint3(i2, j0, l + 64)) * getW7(_Baked, uint4(2, 0, l, k)) +
                            getL6(_Buffer, uint3(i2, j1, l + 64)) * getW7(_Baked, uint4(2, 1, l, k)) +
                            getL6(_Buffer, uint3(i2, j2, l + 64)) * getW7(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN7, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 1 && j == 12 && k == 55) buffer[0] = col.rrrr;
                }
                else if ((time + 9) % _FrameDelay == 0 && insideArea(txL8, px))
                {
                    px -= txL8.xy;
                    uint i = px.y % 52;
                    uint j = px.x % 52;
                    uint k = (px.x / 52) + (px.y / 52) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 64; l++)
                    {
                        sum += getL7(_Buffer, uint3(i0, j0, l)) * getW8(_Baked, uint4(0, 0, l, k)) +
                            getL7(_Buffer, uint3(i0, j1, l)) * getW8(_Baked, uint4(0, 1, l, k)) +
                            getL7(_Buffer, uint3(i0, j2, l)) * getW8(_Baked, uint4(0, 2, l, k)) +
                            getL7(_Buffer, uint3(i1, j0, l)) * getW8(_Baked, uint4(1, 0, l, k)) +
                            getL7(_Buffer, uint3(i1, j1, l)) * getW8(_Baked, uint4(1, 1, l, k)) +
                            getL7(_Buffer, uint3(i1, j2, l)) * getW8(_Baked, uint4(1, 2, l, k)) +
                            getL7(_Buffer, uint3(i2, j0, l)) * getW8(_Baked, uint4(2, 0, l, k)) +
                            getL7(_Buffer, uint3(i2, j1, l)) * getW8(_Baked, uint4(2, 1, l, k)) +
                            getL7(_Buffer, uint3(i2, j2, l)) * getW8(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN8, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 1 && j == 12 && k == 55) buffer[0] = col.rrrr;
                }
                else if ((time + 10) % _FrameDelay == 0 && insideArea(txL9, px))
                {
                    px -= txL9.xy;
                    uint i = px.y % 52;
                    uint j = px.x % 52;
                    uint k = (px.x / 52) + (px.y / 52) * 16;

                    float sum = 0.0;
                    uint l = 0;
                    for (; l < 64; l++)
                    {
                        sum += getL8NoPad(_Buffer, uint3(i, j, l)) * getW9(_Baked, uint2(l, k));
                    }
                    for (; l < 128; l++)
                    {
                        sum += getL7NoPad(_Buffer, uint3(i, j, l - 64)) * getW9(_Baked, uint2(l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN9, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 100 && j == 101 && k == 31) buffer[0] = col.rrrr;
                }
                else if ((time + 11) % _FrameDelay == 0 && insideArea(txL9c96, px))
                {
                    px -= txL9c96.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 16;
                    
                    uint i0 = i * 2, i1 = i0 + 1;
                    uint j0 = j * 2, j1 = j0 + 1;

                    float maxFlt;
                    if (k < 128)
                    {
                        maxFlt = getL6NoPad(_Buffer, uint3(i0, j0, k));
                        maxFlt = max(maxFlt, getL6NoPad(_Buffer, uint3(i0, j1, k)));
                        maxFlt = max(maxFlt, getL6NoPad(_Buffer, uint3(i1, j0, k)));
                        maxFlt = max(maxFlt, getL6NoPad(_Buffer, uint3(i1, j1, k)));
                    }
                    else
                    {
                        uint kn = k - 128;
                        maxFlt = getL9NoPad(_Buffer, uint3(i0, j0, kn));
                        maxFlt = max(maxFlt, getL9NoPad(_Buffer, uint3(i0, j1, kn)));
                        maxFlt = max(maxFlt, getL9NoPad(_Buffer, uint3(i1, j0, kn)));
                        maxFlt = max(maxFlt, getL9NoPad(_Buffer, uint3(i1, j1, kn)));
                    }

                    col.r = maxFlt;
                    // if (i == 25 && j == 24 && k == 1) {
                    //     buffer[0].r = col.r;
                    //     buffer[0].g = getL2NoPad(_Buffer, uint3(102, 55, 1));
                    //     buffer[0].b = getL2NoPad(_Buffer, uint3(103, 54, 1));
                    //     buffer[0].a = getL2NoPad(_Buffer, uint3(103, 55, 1));
                    // }
                }
                else if ((time + 12) % _FrameDelay == 0 && insideArea(txL10, px))
                {
                    px -= txL10.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 256; l++)
                    {
                        sum += getL9c96(_Buffer, uint3(i0, j0, l)) * getW10(_Baked, uint4(0, 0, l, k)) +
                            getL9c96(_Buffer, uint3(i0, j1, l)) * getW10(_Baked, uint4(0, 1, l, k)) +
                            getL9c96(_Buffer, uint3(i0, j2, l)) * getW10(_Baked, uint4(0, 2, l, k)) +
                            getL9c96(_Buffer, uint3(i1, j0, l)) * getW10(_Baked, uint4(1, 0, l, k)) +
                            getL9c96(_Buffer, uint3(i1, j1, l)) * getW10(_Baked, uint4(1, 1, l, k)) +
                            getL9c96(_Buffer, uint3(i1, j2, l)) * getW10(_Baked, uint4(1, 2, l, k)) +
                            getL9c96(_Buffer, uint3(i2, j0, l)) * getW10(_Baked, uint4(2, 0, l, k)) +
                            getL9c96(_Buffer, uint3(i2, j1, l)) * getW10(_Baked, uint4(2, 1, l, k)) +
                            getL9c96(_Buffer, uint3(i2, j2, l)) * getW10(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN10, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 1 && j == 12 && k == 55) buffer[0] = col.rrrr;
                }
                else if ((time + 13) % _FrameDelay == 0 && insideArea(txL11, px))
                {
                    px -= txL11.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 128; l++)
                    {
                        sum += getL10(_Buffer, uint3(i0, j0, l + 128)) * getW11(_Baked, uint4(0, 0, l, k)) +
                            getL10(_Buffer, uint3(i0, j1, l + 128)) * getW11(_Baked, uint4(0, 1, l, k)) +
                            getL10(_Buffer, uint3(i0, j2, l + 128)) * getW11(_Baked, uint4(0, 2, l, k)) +
                            getL10(_Buffer, uint3(i1, j0, l + 128)) * getW11(_Baked, uint4(1, 0, l, k)) +
                            getL10(_Buffer, uint3(i1, j1, l + 128)) * getW11(_Baked, uint4(1, 1, l, k)) +
                            getL10(_Buffer, uint3(i1, j2, l + 128)) * getW11(_Baked, uint4(1, 2, l, k)) +
                            getL10(_Buffer, uint3(i2, j0, l + 128)) * getW11(_Baked, uint4(2, 0, l, k)) +
                            getL10(_Buffer, uint3(i2, j1, l + 128)) * getW11(_Baked, uint4(2, 1, l, k)) +
                            getL10(_Buffer, uint3(i2, j2, l + 128)) * getW11(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN11, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 25 && j == 12 && k == 120) buffer[0] = col.rrrr;
                }
                else if ((time + 14) % _FrameDelay == 0 && insideArea(txL12, px))
                {
                    px -= txL12.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 8;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 128; l++)
                    {
                        sum += getL11(_Buffer, uint3(i0, j0, l)) * getW12(_Baked, uint4(0, 0, l, k)) +
                            getL11(_Buffer, uint3(i0, j1, l)) * getW12(_Baked, uint4(0, 1, l, k)) +
                            getL11(_Buffer, uint3(i0, j2, l)) * getW12(_Baked, uint4(0, 2, l, k)) +
                            getL11(_Buffer, uint3(i1, j0, l)) * getW12(_Baked, uint4(1, 0, l, k)) +
                            getL11(_Buffer, uint3(i1, j1, l)) * getW12(_Baked, uint4(1, 1, l, k)) +
                            getL11(_Buffer, uint3(i1, j2, l)) * getW12(_Baked, uint4(1, 2, l, k)) +
                            getL11(_Buffer, uint3(i2, j0, l)) * getW12(_Baked, uint4(2, 0, l, k)) +
                            getL11(_Buffer, uint3(i2, j1, l)) * getW12(_Baked, uint4(2, 1, l, k)) +
                            getL11(_Buffer, uint3(i2, j2, l)) * getW12(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN12, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 25 && j == 12 && k == 111) buffer[0] = col.rrrr;
                }
                else if ((time + 15) % _FrameDelay == 0 && insideArea(txL13, px))
                {
                    px -= txL13.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 16;

                    float sum = 0.0;
                    uint l = 0;
                    for (; l < 128; l++)
                    {
                        sum += getL12NoPad(_Buffer, uint3(i, j, l)) * getW13(_Baked, uint2(l, k));
                    }
                    for (; l < 256; l++)
                    {
                        sum += getL11NoPad(_Buffer, uint3(i, j, l - 128)) * getW13(_Baked, uint2(l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN13, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 25 && j == 24 && k == 250) buffer[0] = col.rrrr;
                }
                else if ((time + 16) % _FrameDelay == 0 && insideArea(txL13c1310, px))
                {
                    px -= txL13c1310.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 16;
                    
                    uint i0 = i * 2, i1 = i0 + 1;
                    uint j0 = j * 2, j1 = j0 + 1;

                    float maxFlt;
                    if (k < 256)
                    {
                        maxFlt = getL10NoPad(_Buffer, uint3(i0, j0, k));
                        maxFlt = max(maxFlt, getL10NoPad(_Buffer, uint3(i0, j1, k)));
                        maxFlt = max(maxFlt, getL10NoPad(_Buffer, uint3(i1, j0, k)));
                        maxFlt = max(maxFlt, getL10NoPad(_Buffer, uint3(i1, j1, k)));
                    }
                    else
                    {
                        uint kn = k - 256;
                        maxFlt = getL13NoPad(_Buffer, uint3(i0, j0, kn));
                        maxFlt = max(maxFlt, getL13NoPad(_Buffer, uint3(i0, j1, kn)));
                        maxFlt = max(maxFlt, getL13NoPad(_Buffer, uint3(i1, j0, kn)));
                        maxFlt = max(maxFlt, getL13NoPad(_Buffer, uint3(i1, j1, kn)));
                    }

                    col.r = maxFlt;
                    // if (i == 12 && j == 11 && k == 210) {
                    //     buffer[0].r = col.r;
                    //     buffer[0].g = getL2NoPad(_Buffer, uint3(102, 55, 1));
                    //     buffer[0].b = getL2NoPad(_Buffer, uint3(103, 54, 1));
                    //     buffer[0].a = getL2NoPad(_Buffer, uint3(103, 55, 1));
                    // }
                }
                else if ((time + 17) % _FrameDelay == 0 && insideArea(txL14, px))
                {
                    px -= txL14.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 256; l++)
                    {
                        sum += getL13c1310(_Buffer, uint3(i0, j0, l)) * getW14(_Baked, uint4(0, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i0, j1, l)) * getW14(_Baked, uint4(0, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i0, j2, l)) * getW14(_Baked, uint4(0, 2, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j0, l)) * getW14(_Baked, uint4(1, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j1, l)) * getW14(_Baked, uint4(1, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j2, l)) * getW14(_Baked, uint4(1, 2, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j0, l)) * getW14(_Baked, uint4(2, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j1, l)) * getW14(_Baked, uint4(2, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j2, l)) * getW14(_Baked, uint4(2, 2, l, k));
                    }

                    col.r = sum;
                }
                else if ((time + 18) % _FrameDelay == 0 && insideArea(txL14_2, px))
                {
                    px -= txL14_2.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = _Buffer[txL14.xy + px];

                    for (uint l = 256; l < 512; l++)
                    {
                        sum += getL13c1310(_Buffer, uint3(i0, j0, l)) * getW14(_Baked, uint4(0, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i0, j1, l)) * getW14(_Baked, uint4(0, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i0, j2, l)) * getW14(_Baked, uint4(0, 2, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j0, l)) * getW14(_Baked, uint4(1, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j1, l)) * getW14(_Baked, uint4(1, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i1, j2, l)) * getW14(_Baked, uint4(1, 2, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j0, l)) * getW14(_Baked, uint4(2, 0, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j1, l)) * getW14(_Baked, uint4(2, 1, l, k)) +
                            getL13c1310(_Buffer, uint3(i2, j2, l)) * getW14(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN14, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 12 && j == 11 && k == 510) buffer[0] = col.rrrr;
                }
                else if ((time + 19) % _FrameDelay == 0 && insideArea(txL15, px))
                {
                    px -= txL15.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 16;

                    float sum = 0.0;
                    for (uint l = 0; l < 512; l++)
                    {
                        sum += getL14NoPad(_Buffer, uint3(i, j, l)) * getW15(_Baked, uint2(l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN15, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 11 && j == 12 && k == 251) buffer[0] = col.rrrr;
                }
                else if ((time + 20) % _FrameDelay == 0 && insideArea(txL18, px))
                {
                    px -= txL18.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 8;

                    float sum = 0.0;
                    for (uint l = 0; l < 256; l++)
                    {
                        sum += getL15NoPad(_Buffer, uint3(i, j, l)) * getW18(_Baked, uint2(l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN18, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 11 && j == 12 && k == 120) buffer[0] = col.rrrr;
                }
                else if ((time + 21) % _FrameDelay == 0 && insideArea(txL18bu, px))
                {
                    px -= txL18bu.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 16;

                    float ii = i / 25.0;
                    float jj = j / 25.0;
                    float pli = ii * 12.0;
                    float plj = jj * 12.0;
                    float fpli = frac(pli);
                    float fplj = frac(plj);
                    uint pi0 = floor(pli);
                    uint pj0 = floor(plj);
                    uint pi1 = ceil(pli);
                    uint pj1 = ceil(plj);
                    float aa = getL18NoPad(_Buffer, uint3(pi0, pj0, k));
                    float ab = getL18NoPad(_Buffer, uint3(pi0, pj1, k));
                    float ba = getL18NoPad(_Buffer, uint3(pi1, pj0, k));
                    float bb = getL18NoPad(_Buffer, uint3(pi1, pj1, k));
                    float ta = lerp(aa, ba, fpli);
                    float tb = lerp(ab, bb, fpli);
                    col.r = lerp(ta, tb, fplj);
                    //if (i == 19 && j == 25 && k == 101) buffer[0] = col.rrrr;
                }
                else if ((time + 22) % _FrameDelay == 0 && insideArea(txL19, px))
                {
                    px -= txL19.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    uint l = 0;
                    for (; l < 128; l++)
                    {
                        sum += getL18bu(_Buffer, uint3(i0, j0, l)) * getW19(_Baked, uint4(0, 0, l, k)) +
                            getL18bu(_Buffer, uint3(i0, j1, l)) * getW19(_Baked, uint4(0, 1, l, k)) +
                            getL18bu(_Buffer, uint3(i0, j2, l)) * getW19(_Baked, uint4(0, 2, l, k)) +
                            getL18bu(_Buffer, uint3(i1, j0, l)) * getW19(_Baked, uint4(1, 0, l, k)) +
                            getL18bu(_Buffer, uint3(i1, j1, l)) * getW19(_Baked, uint4(1, 1, l, k)) +
                            getL18bu(_Buffer, uint3(i1, j2, l)) * getW19(_Baked, uint4(1, 2, l, k)) +
                            getL18bu(_Buffer, uint3(i2, j0, l)) * getW19(_Baked, uint4(2, 0, l, k)) +
                            getL18bu(_Buffer, uint3(i2, j1, l)) * getW19(_Baked, uint4(2, 1, l, k)) +
                            getL18bu(_Buffer, uint3(i2, j2, l)) * getW19(_Baked, uint4(2, 2, l, k));
                    }
                    for (; l < 384; l++)
                    {
                        sum += getL13(_Buffer, uint3(i0, j0, l - 128)) * getW19(_Baked, uint4(0, 0, l, k)) +
                            getL13(_Buffer, uint3(i0, j1, l - 128)) * getW19(_Baked, uint4(0, 1, l, k)) +
                            getL13(_Buffer, uint3(i0, j2, l - 128)) * getW19(_Baked, uint4(0, 2, l, k)) +
                            getL13(_Buffer, uint3(i1, j0, l - 128)) * getW19(_Baked, uint4(1, 0, l, k)) +
                            getL13(_Buffer, uint3(i1, j1, l - 128)) * getW19(_Baked, uint4(1, 1, l, k)) +
                            getL13(_Buffer, uint3(i1, j2, l - 128)) * getW19(_Baked, uint4(1, 2, l, k)) +
                            getL13(_Buffer, uint3(i2, j0, l - 128)) * getW19(_Baked, uint4(2, 0, l, k)) +
                            getL13(_Buffer, uint3(i2, j1, l - 128)) * getW19(_Baked, uint4(2, 1, l, k)) +
                            getL13(_Buffer, uint3(i2, j2, l - 128)) * getW19(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN19, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 19 && j == 25 && k == 241) buffer[0] = col.rrrr;
                }
                else if ((time + 21) % _FrameDelay == 0 && insideArea(txL16, px))
                {
                    px -= txL16.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 16;

                    uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                    uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                    float sum = 0.0;

                    for (uint l = 0; l < 256; l++)
                    {
                        sum += getL15(_Buffer, uint3(i0, j0, l)) * getW16(_Baked, uint4(0, 0, l, k)) +
                            getL15(_Buffer, uint3(i0, j1, l)) * getW16(_Baked, uint4(0, 1, l, k)) +
                            getL15(_Buffer, uint3(i0, j2, l)) * getW16(_Baked, uint4(0, 2, l, k)) +
                            getL15(_Buffer, uint3(i1, j0, l)) * getW16(_Baked, uint4(1, 0, l, k)) +
                            getL15(_Buffer, uint3(i1, j1, l)) * getW16(_Baked, uint4(1, 1, l, k)) +
                            getL15(_Buffer, uint3(i1, j2, l)) * getW16(_Baked, uint4(1, 2, l, k)) +
                            getL15(_Buffer, uint3(i2, j0, l)) * getW16(_Baked, uint4(2, 0, l, k)) +
                            getL15(_Buffer, uint3(i2, j1, l)) * getW16(_Baked, uint4(2, 1, l, k)) +
                            getL15(_Buffer, uint3(i2, j2, l)) * getW16(_Baked, uint4(2, 2, l, k));
                    }

                    sum = batchNorm(sum, _Baked, txWN16, k);
                    sum = leaky(sum);

                    col.r = sum;
                    //if (i == 10 && j == 11 && k == 511) buffer[0] = col.rrrr;
                }
                else if ((time + 23) % _FrameDelay == 0 && insideArea(txL20, px))
                {
                    px -= txL20.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 17;

                    float sum = 0.0;
                    for (uint l = 0; l < 256; l++)
                    {
                        sum += getL19NoPad(_Buffer, uint3(i, j, l)) * getW20(_Baked, uint2(l, k));
                    }

                    sum += _Baked[txWB20.xy + uint2(0, k)];

                    col.r = sum;
                    //if (i == 21 && j == 19 && k == 212) buffer[0] = col.rrrr;
                }
                else if ((time + 23) % _FrameDelay == 0 && insideArea(txL17, px))
                {
                    px -= txL17.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 15;

                    float sum = 0.0;
                    for (uint l = 0; l < 512; l++)
                    {
                        sum += getL16NoPad(_Buffer, uint3(i, j, l)) * getW17(_Baked, uint2(l, k));
                    }

                    sum += _Baked[txWB17.xy + uint2(0, k)];

                    col.r = sum;
                    //if (i == 11 && j == 5 && k == 212) buffer[0] = col.rrrr;
                }
                else if ((time + 24) % _FrameDelay == 0 && insideArea(txL20_2, px))
                {
                    px -= txL20_2.xy;
                    uint i = px.y % 26;
                    uint j = px.x % 26;
                    uint k = (px.x / 26) + (px.y / 26) * 17;

                    uint l = k / 85;
                    uint m = k % 85;
                    bool scale = m < 2;
                    bool sigmoidOrExp = scale || m >= 4;
                    float grid = m % 2 == 0 ? float(j) : float(i);
                    col.r = _Buffer[txL20.xy + px];
                    col.r = sigmoidOrExp ? sigmoid(col.r) : (exp(col.r) * anchors[0][l][m - 2]);
                    col.r = scale ? ((col.r * 1.05 - 0.025 + grid) * 16.0) : col.r;
                }
                else if ((time + 24) % _FrameDelay == 0 && insideArea(txL17_2, px))
                {
                    px -= txL17_2.xy;
                    uint i = px.y % 13;
                    uint j = px.x % 13;
                    uint k = (px.x / 13) + (px.y / 13) * 15;

                    uint l = k / 85;
                    uint m = k % 85;
                    bool scale = m < 2;
                    bool sigmoidOrExp = scale || m >= 4;
                    float grid = m % 2 == 0 ? float(j) : float(i);
                    col.r = _Buffer[txL17.xy + px];
                    col.r = sigmoidOrExp ? sigmoid(col.r) : (exp(col.r) * anchors[1][l][m - 2]);
                    col.r = scale ? ((col.r * 1.05 - 0.025 + grid) * 32.0) : col.r;

                    //if (i == 12 && j == 5 && k == 88) buffer[0] = col.rrrr;
                    // buffer[0].x = decodeL17(_Buffer, uint4(12, 5, 1, 1)).x;
                    // buffer[0].y = decodeL17(_Buffer, uint4(5, 8, 2, 3)).x;
                    // buffer[0].z = decodeL17(_Buffer, uint4(11, 8, 3, 83)).x;
                }
                return col;
            }
            ENDCG
        }
    }
}
