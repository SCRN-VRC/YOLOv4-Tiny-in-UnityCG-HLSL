#ifndef YOLOV4TINY
#define YOLOV4TINY

// Layers
#define txL0                    uint4( 0 , 0 , 832 , 1664 )
#define txL1                    uint4( 0 , 1664 , 832 , 832 )
#define txL2                    uint4( 832 , 0 , 832 , 832 )
#define txL5                    uint4( 1664 , 0 , 832 , 832 )
#define txL3                    uint4( 2496 , 0 , 416 , 832 )
#define txL4                    uint4( 0 , 2496 , 832 , 416 )
#define txL6                    uint4( 832 , 832 , 832 , 416 )
#define txL9                    uint4( 1664 , 832 , 832 , 416 )
#define txL5c52                    uint4( 2496 , 832 , 416 , 832 )
#define txImgIn0                    uint4( 832 , 1664 , 416 , 416 )
#define txImgIn1                    uint4( 832 , 1248 , 416 , 416 )
#define txImgIn2                    uint4( 832 , 2080 , 416 , 416 )
#define txL7                    uint4( 832 , 2496 , 416 , 416 )
#define txL8                    uint4( 1248 , 1248 , 416 , 416 )
#define txL10                    uint4( 1664 , 1248 , 416 , 416 )
#define txL13                    uint4( 2080 , 1248 , 416 , 416 )
#define txL19                    uint4( 1248 , 1664 , 416 , 416 )
#define txL9c96                    uint4( 1248 , 2080 , 416 , 416 )
#define txL20                    uint4( 1248 , 2496 , 442 , 390 )
#define txL20_2                  uint4( 2275 , 1872 , 442 , 390 )
#define txL11                    uint4( 1664 , 1664 , 208 , 416 )
#define txL12                    uint4( 1664 , 2080 , 208 , 416 )
#define txL14                    uint4( 1690 , 2496 , 208 , 416 )
#define txL14_2                    uint4( 1872 , 1664 , 208 , 416 )
#define txL16                    uint4( 1872 , 2080 , 208 , 416 )
#define txL13c1310                    uint4( 1898 , 2496 , 208 , 416 )
#define txL18bu                    uint4( 2106 , 1664 , 416 , 208 )
#define txL15                    uint4( 2522 , 1664 , 208 , 208 )
#define txL17                    uint4( 2080 , 1872 , 195 , 221 )
#define txL17_2                  uint4( 2080 , 2093 , 195 , 221 )
#define txL18                    uint4( 2730 , 1664 , 104 , 208 )

// Weights
#define txW14                    uint4( 0 , 0 , 2048 , 1152 )
#define txW16                    uint4( 0 , 1152 , 1024 , 1152 )
#define txW19                    uint4( 1024 , 1152 , 1024 , 864 )
#define txW10                    uint4( 1024 , 2016 , 1024 , 576 )
#define txW6                    uint4( 0 , 2304 , 512 , 288 )
#define txW11                    uint4( 512 , 2304 , 512 , 288 )
#define txW12                    uint4( 0 , 2592 , 512 , 288 )
#define txW15                    uint4( 0 , 2880 , 256 , 512 )
#define txW17                    uint4( 0 , 3392 , 255 , 512 )
#define txW13                    uint4( 255 , 3392 , 256 , 256 )
#define txW20                    uint4( 255 , 3648 , 255 , 256 )
#define txW2                    uint4( 0 , 3904 , 256 , 144 )
#define txW7                    uint4( 256 , 3904 , 256 , 144 )
#define txW8                    uint4( 510 , 3648 , 256 , 144 )
#define txW18                    uint4( 512 , 3792 , 128 , 256 )
#define txW1                    uint4( 640 , 3792 , 256 , 72 )
#define txW9                    uint4( 640 , 3864 , 128 , 128 )
#define txW3                    uint4( 640 , 3992 , 128 , 72 )
#define txW4                    uint4( 768 , 3864 , 128 , 72 )
#define txW5                    uint4( 768 , 3936 , 64 , 64 )
#define txWN14                    uint4( 0 , 4064 , 512 , 4 )
#define txWN16                    uint4( 0 , 4048 , 512 , 4 )
#define txWN10                    uint4( 0 , 4052 , 256 , 4 )
#define txWN13                    uint4( 0 , 4056 , 256 , 4 )
#define txWN15                    uint4( 0 , 4060 , 256 , 4 )
#define txWN19                    uint4( 256 , 4052 , 256 , 4 )
#define txW0                    uint4( 0 , 4068 , 96 , 9 )
#define txWN6                    uint4( 512 , 4048 , 128 , 4 )
#define txWN9                    uint4( 512 , 4052 , 128 , 4 )
#define txWN11                    uint4( 512 , 4056 , 128 , 4 )
#define txWN12                    uint4( 512 , 4060 , 128 , 4 )
#define txWN18                    uint4( 256 , 4056 , 128 , 4 )
#define txWN1                    uint4( 256 , 4060 , 64 , 4 )
#define txWN2                    uint4( 320 , 4060 , 64 , 4 )
#define txWN5                    uint4( 384 , 4056 , 64 , 4 )
#define txWN7                    uint4( 448 , 4056 , 64 , 4 )
#define txWN8                    uint4( 384 , 4060 , 64 , 4 )
#define txWB20                    uint4( 256 , 2880 , 1 , 255 )
#define txWB17                    uint4( 256 , 3135 , 1 , 255 )
#define txWN0                    uint4( 448 , 4060 , 32 , 4 )
#define txWN3                    uint4( 480 , 4060 , 32 , 4 )
#define txWN4                    uint4( 0 , 4077 , 32 , 4 )

#define txTimeDelta              uint2( 2919, 2919 )
#define txLayerCounter           uint2( 2918, 2919 )
#define txPeriod                 uint2( 2917, 2919 )

#define ALPHA 0.1
#define EPS 0.001

#define mod(x,y) ((x)-(y)*floor((x)/(y))) // glsl mod

// Default anchor positions for each cell
// tiny network only has 2 layers of 3
static const float anchors[2][3][2] =
{
    23,27,
    37,58,
    81,82,

    81,82,
    135,169,
    344,319
};

// float testGen(uint3 pos)
// {
//     float r;
//     if(pos.x > 416 || pos.y > 416) return 0.0;
//     if (pos.z == 0)
//         r = (pos.x / 415.0) * (pos.y / 415.0);
//     else if (pos.z == 1)
//         r = ((415.0 - pos.x) / 415.0) * (pos.y /  415.0);
//     else
//         r = (pos.x / 415.0) * ((415.0 - pos.y) /  415.0);
//     return r;
// }

// float test(uint3 pos)
// {
//     if (pos.x == 0 || pos.y == 0) return 0.0;
//     return testGen(uint3(pos.xy - 1, pos.z));
// }

inline void StoreValue(in uint2 txPos, in float value, inout float col,
    in uint2 fragPos)
{
    col = all(fragPos == txPos) ? value : col;
}

void pR(inout float2 p, float a) {
    p = cos(a)*p + sin(a)*float2(p.y, -p.x);
}

inline bool insideArea(in uint4 area, uint2 px)
{
    if (px.x >= area.x && px.x < (area.x + area.z) &&
        px.y >= area.y && px.y < (area.y + area.w))
    {
        return true;
    }
    return false;
}

float leaky(float x)
{
    return x < 0.0 ? ALPHA * x : x;
}

float sigmoid(float x)
{
    return 1.0 / (1.0 + exp(-x));
}

float batchNorm(float sum, Texture2D<float> tex, uint4 base, uint k)
{
    float gamma = tex[base.xy + uint2(k, 0)].r;
    float beta = tex[base.xy + uint2(k, 1)].r;
    float mean = tex[base.xy + uint2(k, 2)].r;
    float var = tex[base.xy + uint2(k, 3)].r;
    return ((sum - mean) / sqrt(var + EPS)) * gamma + beta;
}

// Valid padding
float getImg(Texture2D<float> tex, uint2 base, uint x, uint y)
{
    if (x == 0 || y == 0) return 0.0;
    return tex[base + uint2(x - 1, y - 1)].r;
}

float getW0(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + off.z * 32;
    pos.y = off.y + off.x * 3;
    return tex[txW0.xy + pos].r;
}

float getL0(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 4) * 208;
    pos.y = off.x + (off.z / 4) * 208;
    return tex[txL0.xy + pos].r;
}

float getW1(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 64;
    pos.y = (off.z / 4) + off.y * 8 + off.x * 24;
    return tex[txW1.xy + pos].r;
}

// Even padding
float getL1(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 104)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 104;
    pos.y = off.x + (off.z / 8) * 104;
    return tex[txL1.xy + pos].r;
}

float getW2(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 64;
    pos.y = (off.z / 4) + off.y * 16 + off.x * 48;
    return tex[txW2.xy + pos].r;
}

float getL2(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 104)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 104;
    pos.y = off.x + (off.z / 8) * 104;
    return tex[txL2.xy + pos].r;
}

float getW3(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 32;
    pos.y = (off.z / 4) + off.y * 8 + off.x * 24;
    return tex[txW3.xy + pos].r;
}

float getL3(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 104)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 4) * 104;
    pos.y = off.x + (off.z / 4) * 104;
    return tex[txL3.xy + pos].r;
}

float getW4(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 32;
    pos.y = (off.z / 4) + off.y * 8 + off.x * 24;
    return tex[txW4.xy + pos].r;
}

float getL3NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 4) * 104;
    pos.y = off.x + (off.z / 4) * 104;
    return tex[txL3.xy + pos].r;
}

float getL4NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 104;
    pos.y = off.x + (off.z / 8) * 104;
    return tex[txL4.xy + pos].r;
}

float getW5(Texture2D<float> tex, uint2 off)
{
    return tex[txW5.xy + off.yx].r;
}

float getL2NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 104;
    pos.y = off.x + (off.z / 8) * 104;
    return tex[txL2.xy + pos].r;
}

float getL5NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 104;
    pos.y = off.x + (off.z / 8) * 104;
    return tex[txL5.xy + pos].r;
}

float getL5c52(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 52)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 52;
    pos.y = off.x + (off.z / 8) * 52;
    return tex[txL5c52.xy + pos].r;
}

float getW6(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 128;
    pos.y = (off.z / 4) + off.y * 32 + off.x * 96;
    return tex[txW6.xy + pos].r;
}

float getL6(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 52)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 52;
    pos.y = off.x + (off.z / 16) * 52;
    return tex[txL6.xy + pos].r;
}

float getW7(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 64;
    pos.y = (off.z / 4) + off.y * 16 + off.x * 48;
    return tex[txW7.xy + pos].r;
}

float getL7(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 52)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 52;
    pos.y = off.x + (off.z / 8) * 52;
    return tex[txL7.xy + pos].r;
}

float getW8(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 64;
    pos.y = (off.z / 4) + off.y * 16 + off.x * 48;
    return tex[txW8.xy + pos].r;
}

float getL7NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 52;
    pos.y = off.x + (off.z / 8) * 52;
    return tex[txL7.xy + pos].r;
}

float getL8NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 52;
    pos.y = off.x + (off.z / 8) * 52;
    return tex[txL8.xy + pos].r;
}

float getW9(Texture2D<float> tex, uint2 off)
{
    return tex[txW9.xy + off.yx].r;
}

float getL6NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 52;
    pos.y = off.x + (off.z / 16) * 52;
    return tex[txL6.xy + pos].r;
}

float getL9NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 52;
    pos.y = off.x + (off.z / 16) * 52;
    return tex[txL9.xy + pos].r;
}

float getL9c96(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 26)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL9c96.xy + pos].r;
}

float getW10(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 256;
    pos.y = (off.z / 4) + off.y * 64 + off.x * 192;
    return tex[txW10.xy + pos].r;
}

float getL10(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 26)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL10.xy + pos].r;
}

float getW11(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 128;
    pos.y = (off.z / 4) + off.y * 32 + off.x * 96;
    return tex[txW11.xy + pos].r;
}

float getL11(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 26)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 26;
    pos.y = off.x + (off.z / 8) * 26;
    return tex[txL11.xy + pos].r;
}

float getW12(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 128;
    pos.y = (off.z / 4) + off.y * 32 + off.x * 96;
    return tex[txW12.xy + pos].r;
}

float getL11NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 26;
    pos.y = off.x + (off.z / 8) * 26;
    return tex[txL11.xy + pos].r;
}

float getL12NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 26;
    pos.y = off.x + (off.z / 8) * 26;
    return tex[txL12.xy + pos].r;
}

float getW13(Texture2D<float> tex, uint2 off)
{
    return tex[txW13.xy + off.yx].r;
}

float getL10NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL10.xy + pos].r;
}

float getL13NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL13.xy + pos].r;
}

float getL13c1310(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 13)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 13;
    pos.y = off.x + (off.z / 16) * 13;
    return tex[txL13c1310.xy + pos].r;
}

float getW14(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 512;
    pos.y = (off.z / 4) + off.y * 128 + off.x * 384;
    return tex[txW14.xy + pos].r;
}

float getL14NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 13;
    pos.y = off.x + (off.z / 16) * 13;
    return tex[txL14_2.xy + pos].r;
}

float getW15(Texture2D<float> tex, uint2 off)
{
    return tex[txW15.xy + off.yx].r;
}

float getL15NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 13;
    pos.y = off.x + (off.z / 16) * 13;
    return tex[txL15.xy + pos].r;
}

float getW18(Texture2D<float> tex, uint2 off)
{
    return tex[txW18.xy + off.yx].r;
}

float getL18NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 8) * 13;
    pos.y = off.x + (off.z / 8) * 13;
    return tex[txL18.xy + pos].r;
}

float getL13(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 26)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL13.xy + pos].r;
}

float getL18bu(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 26)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL18bu.xy + pos].r;
}

float getW19(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 4) * 256;
    pos.y = (off.z / 4) + off.y * 96 + off.x * 288;
    return tex[txW19.xy + pos].r;
}

float getL15(Texture2D<float> tex, uint3 off)
{
    if (any(off.xy == 0) || any(off.xy > 13)) return 0.0;
    off.xy -= 1;
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 13;
    pos.y = off.x + (off.z / 16) * 13;
    return tex[txL15.xy + pos].r;
}

float getW16(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    pos.x = off.w + (off.z % 2) * 512;
    pos.y = (off.z / 2) + off.y * 128 + off.x * 384;
    return tex[txW16.xy + pos].r;
}

float getL19NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 26;
    pos.y = off.x + (off.z / 16) * 26;
    return tex[txL19.xy + pos].r;
}

float getW20(Texture2D<float> tex, uint2 off)
{
    return tex[txW20.xy + off.yx].r;
}

float getL16NoPad(Texture2D<float> tex, uint3 off)
{
    uint2 pos;
    pos.x = off.y + (off.z % 16) * 13;
    pos.y = off.x + (off.z / 16) * 13;
    return tex[txL16.xy + pos].r;
}

float getW17(Texture2D<float> tex, uint2 off)
{
    return tex[txW17.xy + off.yx].r;
}

float decodeL20(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    off.z = off.z * 85 + off.w;
    pos.x = off.y + (off.z % 17) * 26;
    pos.y = off.x + (off.z / 17) * 26;
    return tex[txL20_2.xy + pos].r;
}

float decodeL17(Texture2D<float> tex, uint4 off)
{
    uint2 pos;
    off.z = off.z * 85 + off.w;
    pos.x = off.y + (off.z % 15) * 13;
    pos.y = off.x + (off.z / 15) * 13;
    return tex[txL17_2.xy + pos].r;
}

#endif