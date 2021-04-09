#ifndef YOLOV4TINY_NMS
#define YOLOV4TINY_NMS

#define mod(x,y) ((x)-(y)*floor((x)/(y))) // glsl mod

#define txL20simp                    uint4( 0 , 0 , 26 , 26 )
#define txL17simp                    uint4( 0 , 26 , 13 , 13 )
#define txL20nms                    uint4( 26 , 0 , 26 , 26 )
#define txL17nms                    uint4( 13 , 26 , 13 , 13 )
#define txConfidence                uint4(63, 63, 1, 1)

static const uint4 f16zero = asuint(f32tof16(0.0)).xxxx;

/*
    http://ronny.rest/tutorials/module/localization_001/iou/
    
    Given two boxes `a` and `b` defined as a list of four numbers:
        [x1,y1,x2,y2]
    where:
        x1,y1 represent the upper left corner
        x2,y2 represent the lower right corner
    It returns the Intersect of Union score for these two boxes.
*/
float get_iou(float4 a, float4 b)
{
    float x1 = max(a[0], b[0]);
    float y1 = max(a[1], b[1]);
    float x2 = min(a[2], b[2]);
    float y2 = min(a[3], b[3]);

    float width = (x2 - x1);
    float height = (y2 - y1);

    if (width < 0 || height < 0) return 0.0;

    float area_overlap = width * height;
    float area_a = (a[2] - a[0]) * (a[3] - a[1]);
    float area_b = (b[2] - b[0]) * (b[3] - b[1]);
    float area_combined = area_a + area_b - area_overlap;

    return area_overlap / (area_combined + 0.001);
}

float sdBox( in float2 p, in float2 b )
{
    float2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x,d.y), 0.0);
}

float opOnionBox( in float2 p, in float2 b, in float r )
{
    return abs(sdBox(p, b)) - r;
}

float4 HueShift (in float3 Color, in float Shift)
{
    float3 P = 0.55735.xxx*dot(0.55735.xxx,Color);
    
    float3 U = Color-P;
    
    float3 V = cross(0.55735.xxx,U);    

    Color = U*cos(Shift*6.2832) + V*sin(Shift*6.2832) + P;
    
    return float4(Color,1.0);
}

#endif