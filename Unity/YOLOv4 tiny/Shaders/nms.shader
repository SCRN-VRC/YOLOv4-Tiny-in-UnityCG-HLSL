﻿Shader "YOLOv4Tiny/nms"
{
    Properties
    {
        _YOLOout ("YOLO Output", 2D) = "black" {}
        _Buffer ("Buffer", 2D) = "black" {}
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
            #include "nms_include.cginc"

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
            Texture2D<float> _YOLOout;
            Texture2D<uint4> _Buffer;

            float4 _Buffer_TexelSize;
            float _MaxDist;

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

            uint4 frag (v2f fs) : SV_Target
            {
                clip(fs.uv.z);
                uint2 px = fs.uv.xy * _Buffer_TexelSize.zw;
                
                uint4 col = asuint(_Buffer[px]);
                uint time = mod(floor(_Time.y * 30), 5.0);

                if (time == 0 && insideArea(txL20simp, px))
                {
                    px -= txL20simp.xy;

                    uint iAnchor = 0;
                    float conf0 = decodeL20(_YOLOout, uint4(px.x, px.y, 0, 4));
                    float conf1 = decodeL20(_YOLOout, uint4(px.x, px.y, 1, 4));
                    float conf2 = decodeL20(_YOLOout, uint4(px.x, px.y, 2, 4));
                    iAnchor = conf0 < conf1 ? 1 : iAnchor;
                    conf0 = conf0 < conf1 ? conf1 : conf0;
                    iAnchor = conf0 < conf2 ? 2 : iAnchor;
                    conf0 = conf0 < conf2 ? conf2 : conf0;

                    float x = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, 0));
                    float y = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, 1));
                    float w = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, 2));
                    float h = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, 3));

                    uint bestIndex = 5;
                    float bestProb = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, bestIndex));
                    for (uint i = 6; i < 85; i++) {
                        float prob = decodeL20(_YOLOout, uint4(px.x, px.y, iAnchor, i));
                        bestIndex = bestProb < prob ? i : bestIndex;
                        bestProb = bestProb < prob ? prob : bestProb;
                    }
                    bestIndex -= 5;

                    col.r = asuint(f32tof16(x)) << 16;
                    col.g = asuint(f32tof16(w)) << 16;
                    col.b = asuint(f32tof16(bestIndex)) << 16;

                    col.r |= asuint(f32tof16(y));
                    col.g |= asuint(f32tof16(h));
                    col.b |= asuint(f32tof16(bestProb));
                    col.a = asuint(f32tof16(conf0));
                }
                else if (time == 1 && insideArea(txL17simp, px))
                {
                    px -= txL17simp.xy;

                    uint iAnchor = 0;
                    float conf0 = decodeL17(_YOLOout, uint4(px.x, px.y, 0, 4));
                    float conf1 = decodeL17(_YOLOout, uint4(px.x, px.y, 1, 4));
                    float conf2 = decodeL17(_YOLOout, uint4(px.x, px.y, 2, 4));
                    iAnchor = conf0 < conf1 ? 1 : iAnchor;
                    conf0 = conf0 < conf1 ? conf1 : conf0;
                    iAnchor = conf0 < conf2 ? 2 : iAnchor;
                    conf0 = conf0 < conf2 ? conf2 : conf0;

                    float x = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, 0));
                    float y = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, 1));
                    float w = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, 2));
                    float h = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, 3));

                    uint bestIndex = 5;
                    float bestProb = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, bestIndex));
                    for (uint i = 6; i < 85; i++) {
                        float prob = decodeL17(_YOLOout, uint4(px.x, px.y, iAnchor, i));
                        bestIndex = bestProb < prob ? i : bestIndex;
                        bestProb = bestProb < prob ? prob : bestProb;
                    }
                    bestIndex -= 5;

                    col.r = asuint(f32tof16(x)) << 16;
                    col.g = asuint(f32tof16(w)) << 16;
                    col.b = asuint(f32tof16(bestIndex)) << 16;

                    col.r |= asuint(f32tof16(y));
                    col.g |= asuint(f32tof16(h));
                    col.b |= asuint(f32tof16(bestProb));
                    col.a = asuint(f32tof16(conf0));
                }
                else if (time == 2 && insideArea(txL20nms, px))
                {
                    px -= txL20nms.xy;

                    uint4 curBuf = asuint(_Buffer[txL20simp + px]);
                    float myConf = f16tof32(curBuf.a);
                    if (myConf > 0.5) {
                        float myClass = f16tof32(curBuf.b >> 16);
                        float x = f16tof32(curBuf.r >> 16);
                        float y = f16tof32(curBuf.r);
                        float w = f16tof32(curBuf.g >> 16);
                        float h = f16tof32(curBuf.g);
                        float4 box_a = float4(x - w * 0.5, y - h * 0.5,
                            x + w * 0.5, y + h * 0.5);

                        uint i;
                        uint j;
                        for (i = 0; i < 26; i++) {
                            for (j = 0; j < 26; j++) {
                                //if (myConf < 0.5) return f16zero;
                                uint4 buff = asuint(_Buffer[txL20simp + uint2(i, j)]);
                                float bclass = f16tof32(buff.b >> 16);
                                float conf = f16tof32(buff.a);
                                float bx = f16tof32(buff.r >> 16);
                                float by = f16tof32(buff.r);
                                float bw = f16tof32(buff.g >> 16);
                                float bh = f16tof32(buff.g);
                                float4 box_b = float4(bx - bw * 0.5, by - bh * 0.5,
                                    bx + bw * 0.5, by + bh * 0.5);
                                float iou = get_iou(box_a, box_b);
                                bool suppress = abs(myClass - bclass) < 0.001 && (conf > myConf) &&
                                    (iou > 0.5);
                                myConf = suppress ? 0.0 : myConf; 
                            }
                        }

                        for (i = 0; i < 13; i++) {
                            for (j = 0; j < 13; j++) {
                                //if (myConf < 0.5) return f16zero;
                                uint4 buff = asuint(_Buffer[txL17simp + uint2(i, j)]);
                                float bclass = f16tof32(buff.b >> 16);
                                float conf = f16tof32(buff.a);
                                float bx = f16tof32(buff.r >> 16);
                                float by = f16tof32(buff.r);
                                float bw = f16tof32(buff.g >> 16);
                                float bh = f16tof32(buff.g);
                                float4 box_b = float4(bx - bw * 0.5, by - bh * 0.5,
                                    bx + bw * 0.5, by + bh * 0.5);
                                float iou = get_iou(box_a, box_b);
                                bool suppress = abs(myClass - bclass) < 0.001 && (conf > myConf) &&
                                    (iou > 0.5);
                                myConf = suppress ? 0.0 : myConf;
                            }
                        }

                        col.rgb = curBuf.rgb;
                        col.a = asuint(f32tof16(myConf));
                    }
                    else col.a = f16zero.r;
                }
                else if (time == 3 && insideArea(txL17nms, px))
                {
                    px -= txL17nms.xy;

                    uint4 curBuf = asuint(_Buffer[txL17simp + px]);
                    float myConf = f16tof32(curBuf.a);
                    if (myConf > 0.5) {
                        float myClass = f16tof32(curBuf.b >> 16);
                        float x = f16tof32(curBuf.r >> 16);
                        float y = f16tof32(curBuf.r);
                        float w = f16tof32(curBuf.g >> 16);
                        float h = f16tof32(curBuf.g);
                        float4 box_a = float4(x - w * 0.5, y - h * 0.5,
                            x + w * 0.5, y + h * 0.5);

                        uint i;
                        uint j;
                        for (i = 0; i < 26; i++) {
                            for (j = 0; j < 26; j++) {
                                //if (myConf < 0.5) return f16zero;
                                uint4 buff = asuint(_Buffer[txL20simp + uint2(i, j)]);
                                float conf = f16tof32(buff.a);
                                float bclass = f16tof32(buff.b >> 16);
                                float bx = f16tof32(buff.r >> 16);
                                float by = f16tof32(buff.r);
                                float bw = f16tof32(buff.g >> 16);
                                float bh = f16tof32(buff.g);
                                float4 box_b = float4(bx - bw * 0.5, by - bh * 0.5,
                                    bx + bw * 0.5, by + bh * 0.5);
                                float iou = get_iou(box_a, box_b);
                                bool suppress = abs(myClass - bclass) < 0.001 && (conf > myConf) &&
                                    (iou > 0.5);
                                myConf = suppress ? 0.0 : myConf; 
                            }
                        }

                        for (i = 0; i < 13; i++) {
                            for (j = 0; j < 13; j++) {
                                //if (myConf < 0.5) return f16zero;
                                uint4 buff = asuint(_Buffer[txL17simp + uint2(i, j)]);
                                float conf = f16tof32(buff.a);
                                float bclass = f16tof32(buff.b >> 16);
                                float bx = f16tof32(buff.r >> 16);
                                float by = f16tof32(buff.r);
                                float bw = f16tof32(buff.g >> 16);
                                float bh = f16tof32(buff.g);
                                float4 box_b = float4(bx - bw * 0.5, by - bh * 0.5,
                                    bx + bw * 0.5, by + bh * 0.5);
                                float iou = get_iou(box_a, box_b);
                                //buffer[0] = 
                                bool suppress = abs(myClass - bclass) < 0.001 && (conf > myConf) &&
                                    (iou > 0.5);
                                myConf = suppress ? 0.0 : myConf;
                            }
                        }
                        col.rgb = curBuf.rgb;
                        col.a = asuint(f32tof16(myConf));
                    }
                    else col.a = f16zero.r;

                    // uint c = 0;
                    // for (uint i = 0; i < 13; i++) {
                    //     for (uint j = 0; j < 13; j++) {
                    //         uint4 buff = asuint(_Buffer[txL17nms + uint2(i, j)]);
                    //         float conf = f16tof32(buff.a);
                    //         float bx = f16tof32(buff.r >> 16);
                    //         float by = f16tof32(buff.r);
                    //         if (conf > 0.5) c++;
                    //         //if (c == 2) buffer[0] = float4(i, j, bx, by);
                    //     }
                    // }
                    // buffer[0] = c;
                }

                return col;
            }
            ENDCG
        }
    }
}