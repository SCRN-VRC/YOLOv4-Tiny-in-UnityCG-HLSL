Shader "YOLOv4Tiny/output"
{
    Properties
    {
        _NMSout ("NMS Output", 2D) = "black" {}
        _MainTex ("Texture", 2D) = "black" {}
        _Classes ("Classes", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "nms_include.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //RWStructuredBuffer<float4> buffer : register(u1);
            Texture2D<uint4> _NMSout;
            sampler2D _MainTex;
            sampler2D _Classes;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f fs) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, fs.uv);
                float Confidence = _NMSout[txConfidence.xy].r;
                const float2 scale = 0.5.xx;

                uint i;
                uint j;

                // Loop through the 26x26 grid output
                for (i = 0; i < 26; i++) {
                    for (j = 0; j < 26; j++) {
                        // Only draw a box if the confidence is over 50%
                        uint4 buff = asuint(_NMSout[txL20nms.xy + uint2(i, j)]);
                        float conf = f16tof32(buff.a);
                        [branch]
                        if (conf > Confidence) {
                            // Class, 0 to 79
                            float c = f16tof32(buff.b >> 16);
                            // x, y is the center position of the
                            // bbox relative to 416, the input size
                            float x = f16tof32(buff.r >> 16);
                            float y = f16tof32(buff.r);
                            // w, h are the width and height relative to
                            // 416, the input size
                            float w = f16tof32(buff.g >> 16);
                            float h = f16tof32(buff.g);
                            // Scale to camera resolution using UVs
                            float2 center = float2(x, y) / 416.0;
                            center.y = 1.0 - center.y;
                            float2 size = float2(w, h) / 416.0 * scale;
                            float d = opOnionBox(fs.uv - center, size, 0.001);
                            float3 trgCol = HueShift(float3(1.0 - mod(c / 2.7, 0.73), 0.0, 0.0), c / 2.7);
                            // Draw the text above the box
                            float2 labelSize = float2(0.07, 0.021);
                            float2 labelCenter = float2(center + float2(-size.x, size.y) + labelSize);
                            [branch]
                            if (all(abs(fs.uv - labelCenter) < labelSize)) {
                                float2 labelUV = ((fs.uv - labelCenter) / labelSize) * 0.5 + 0.5;
                                float2 texelSize = 1.0 / float2(4.0, 20.0);
                                labelUV = labelUV * texelSize + float2(mod(c, 4.0), 19.0 - floor(c / 4.0)) * texelSize;
                                float text = tex2D(_Classes, labelUV).r;
                                col.rgb = lerp(trgCol, 0..rrr, text * 2.0);
                            }
                            col.rgb = lerp(col.rgb, trgCol, 1.0 - saturate(d * 1000.0));
                        }
                    }
                }

                // Loop through the 13x13 grid output
                for (i = 0; i < 13; i++) {
                    for (j = 0; j < 13; j++) {
                        // Only draw a box if the confidence is over 50%
                        uint4 buff = asuint(_NMSout[txL17nms.xy + uint2(i, j)]);
                        float conf = f16tof32(buff.a);
                        [branch]
                        if (conf > Confidence) {
                            // Class, 0 to 79
                            float c = f16tof32(buff.b >> 16);
                            // x, y is the center position of the
                            // bbox relative to 416, the input size
                            float x = f16tof32(buff.r >> 16);
                            float y = f16tof32(buff.r);
                            // w, h are the width and height relative to
                            // 416, the input size
                            float w = f16tof32(buff.g >> 16);
                            float h = f16tof32(buff.g);
                            // Scale to camera resolution using UVs
                            float2 center = float2(x, y) / 416.0;
                            center.y = 1.0 - center.y;
                            float2 size = float2(w, h) / 416.0 * scale;
                            float d = opOnionBox(fs.uv - center, size, 0.001);
                            float3 trgCol = HueShift(float3(1.0 - mod(c / 2.7, 0.73), 0.0, 0.0), c / 2.7);
                            // Draw the text above the box
                            float2 labelSize = float2(0.07, 0.021);
                            float2 labelCenter = float2(center + float2(-size.x, size.y) + labelSize);
                            [branch]
                            if (all(abs(fs.uv - labelCenter) < labelSize)) {
                                float2 labelUV = ((fs.uv - labelCenter) / labelSize) * 0.5 + 0.5;
                                float2 texelSize = 1.0 / float2(4.0, 20.0);
                                labelUV = labelUV * texelSize + float2(mod(c, 4.0), 19.0 - floor(c / 4.0)) * texelSize;
                                float text = tex2D(_Classes, labelUV).r;
                                col.rgb = lerp(trgCol, 0..rrr, text * 2.0);
                            }
                            col.rgb = lerp(col.rgb, trgCol, 1.0 - saturate(d * 1000.0));
                        }
                    }
                }

                // apply fog
                UNITY_APPLY_FOG(fs.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
    Fallback "Standard"
}
