/*

    yolov4-tiny setup in C++
    reference: https://github.com/hunglc007/tensorflow-yolov4-tflite

    The purpose of this file is to accurately replicate the outputs of tensorflow
    without using the tensorflow library so I can port it into HLSL/Unity CG.

    Naive implementation, will run very slow.

    - SCRN

__________________________________________________________________________________________________
Layer (type)                    Output Shape         Param #     Connected to
==================================================================================================
input_1 (InputLayer)            [(None, 416, 416, 3) 0
__________________________________________________________________________________________________
zero_padding2d (ZeroPadding2D)  (None, 417, 417, 3)  0           input_1[0][0]
__________________________________________________________________________________________________
conv2d (Conv2D) 2               (None, 208, 208, 32) 864         zero_padding2d[0][0]
__________________________________________________________________________________________________
batch_normalization (BatchNorma (None, 208, 208, 32) 128         conv2d[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu (TensorFl [(None, 208, 208, 32 0           batch_normalization[0][0]
__________________________________________________________________________________________________
zero_padding2d_1 (ZeroPadding2D (None, 209, 209, 32) 0           tf_op_layer_LeakyRelu[0][0]
__________________________________________________________________________________________________
conv2d_1 (Conv2D) 6             (None, 104, 104, 64) 18432       zero_padding2d_1[0][0]
__________________________________________________________________________________________________
batch_normalization_1 (BatchNor (None, 104, 104, 64) 256         conv2d_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_1 (Tensor [(None, 104, 104, 64 0           batch_normalization_1[0][0]
__________________________________________________________________________________________________
conv2d_2 (Conv2D) 9             (None, 104, 104, 64) 36864       tf_op_layer_LeakyRelu_1[0][0]
__________________________________________________________________________________________________
batch_normalization_2 (BatchNor (None, 104, 104, 64) 256         conv2d_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_2 (Tensor [(None, 104, 104, 64 0           batch_normalization_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_split (TensorFlowOp [(None, 104, 104, 32 0           tf_op_layer_LeakyRelu_2[0][0]
__________________________________________________________________________________________________
conv2d_3 (Conv2D) 13            (None, 104, 104, 32) 9216        tf_op_layer_split[0][1]
__________________________________________________________________________________________________
batch_normalization_3 (BatchNor (None, 104, 104, 32) 128         conv2d_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_3 (Tensor [(None, 104, 104, 32 0           batch_normalization_3[0][0]
__________________________________________________________________________________________________
conv2d_4 (Conv2D) 16            (None, 104, 104, 32) 9216        tf_op_layer_LeakyRelu_3[0][0]
__________________________________________________________________________________________________
batch_normalization_4 (BatchNor (None, 104, 104, 32) 128         conv2d_4[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_4 (Tensor [(None, 104, 104, 32 0           batch_normalization_4[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat (TensorFlowO [(None, 104, 104, 64 0           tf_op_layer_LeakyRelu_4[0][0]
                                                                 tf_op_layer_LeakyRelu_3[0][0]
__________________________________________________________________________________________________
conv2d_5 (Conv2D)  20           (None, 104, 104, 64) 4096        tf_op_layer_concat[0][0]
__________________________________________________________________________________________________
batch_normalization_5 (BatchNor (None, 104, 104, 64) 256         conv2d_5[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_5 (Tensor [(None, 104, 104, 64 0           batch_normalization_5[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_1 (TensorFlo [(None, 104, 104, 12 0           tf_op_layer_LeakyRelu_2[0][0]
                                                                 tf_op_layer_LeakyRelu_5[0][0]
__________________________________________________________________________________________________
max_pooling2d (MaxPooling2D)    (None, 52, 52, 128)  0           tf_op_layer_concat_1[0][0]
__________________________________________________________________________________________________
conv2d_6 (Conv2D)  25           (None, 52, 52, 128)  147456      max_pooling2d[0][0]
__________________________________________________________________________________________________
batch_normalization_6 (BatchNor (None, 52, 52, 128)  512         conv2d_6[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_6 (Tensor [(None, 52, 52, 128) 0           batch_normalization_6[0][0]
__________________________________________________________________________________________________
tf_op_layer_split_1 (TensorFlow [(None, 52, 52, 64), 0           tf_op_layer_LeakyRelu_6[0][0]
__________________________________________________________________________________________________
conv2d_7 (Conv2D) 29            (None, 52, 52, 64)   36864       tf_op_layer_split_1[0][1]
__________________________________________________________________________________________________
batch_normalization_7 (BatchNor (None, 52, 52, 64)   256         conv2d_7[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_7 (Tensor [(None, 52, 52, 64)] 0           batch_normalization_7[0][0]
__________________________________________________________________________________________________
conv2d_8 (Conv2D) 32            (None, 52, 52, 64)   36864       tf_op_layer_LeakyRelu_7[0][0]
__________________________________________________________________________________________________
batch_normalization_8 (BatchNor (None, 52, 52, 64)   256         conv2d_8[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_8 (Tensor [(None, 52, 52, 64)] 0           batch_normalization_8[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_2 (TensorFlo [(None, 52, 52, 128) 0           tf_op_layer_LeakyRelu_8[0][0]
                                                                 tf_op_layer_LeakyRelu_7[0][0]
__________________________________________________________________________________________________
conv2d_9 (Conv2D)  36           (None, 52, 52, 128)  16384       tf_op_layer_concat_2[0][0]
__________________________________________________________________________________________________
batch_normalization_9 (BatchNor (None, 52, 52, 128)  512         conv2d_9[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_9 (Tensor [(None, 52, 52, 128) 0           batch_normalization_9[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_3 (TensorFlo [(None, 52, 52, 256) 0           tf_op_layer_LeakyRelu_6[0][0]
                                                                 tf_op_layer_LeakyRelu_9[0][0]
__________________________________________________________________________________________________
max_pooling2d_1 (MaxPooling2D)  (None, 26, 26, 256)  0           tf_op_layer_concat_3[0][0]
__________________________________________________________________________________________________
conv2d_10 (Conv2D) 41           (None, 26, 26, 256)  589824      max_pooling2d_1[0][0]
__________________________________________________________________________________________________
batch_normalization_10 (BatchNo (None, 26, 26, 256)  1024        conv2d_10[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_10 (Tenso [(None, 26, 26, 256) 0           batch_normalization_10[0][0]
__________________________________________________________________________________________________
tf_op_layer_split_2 (TensorFlow [(None, 26, 26, 128) 0           tf_op_layer_LeakyRelu_10[0][0]
__________________________________________________________________________________________________
conv2d_11 (Conv2D) 45           (None, 26, 26, 128)  147456      tf_op_layer_split_2[0][1]
__________________________________________________________________________________________________
batch_normalization_11 (BatchNo (None, 26, 26, 128)  512         conv2d_11[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_11 (Tenso [(None, 26, 26, 128) 0           batch_normalization_11[0][0]
__________________________________________________________________________________________________
conv2d_12 (Conv2D) 48           (None, 26, 26, 128)  147456      tf_op_layer_LeakyRelu_11[0][0]
__________________________________________________________________________________________________
batch_normalization_12 (BatchNo (None, 26, 26, 128)  512         conv2d_12[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_12 (Tenso [(None, 26, 26, 128) 0           batch_normalization_12[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_4 (TensorFlo [(None, 26, 26, 256) 0           tf_op_layer_LeakyRelu_12[0][0]
                                                                 tf_op_layer_LeakyRelu_11[0][0]
__________________________________________________________________________________________________
conv2d_13 (Conv2D) 52           (None, 26, 26, 256)  65536       tf_op_layer_concat_4[0][0]
__________________________________________________________________________________________________
batch_normalization_13 (BatchNo (None, 26, 26, 256)  1024        conv2d_13[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_13 (Tenso [(None, 26, 26, 256) 0           batch_normalization_13[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_5 (TensorFlo [(None, 26, 26, 512) 0           tf_op_layer_LeakyRelu_10[0][0]
                                                                 tf_op_layer_LeakyRelu_13[0][0]
__________________________________________________________________________________________________
max_pooling2d_2 (MaxPooling2D)  (None, 13, 13, 512)  0           tf_op_layer_concat_5[0][0]
__________________________________________________________________________________________________
conv2d_14 (Conv2D)  57          (None, 13, 13, 512)  2359296     max_pooling2d_2[0][0]
__________________________________________________________________________________________________
batch_normalization_14 (BatchNo (None, 13, 13, 512)  2048        conv2d_14[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_14 (Tenso [(None, 13, 13, 512) 0           batch_normalization_14[0][0]
__________________________________________________________________________________________________
conv2d_15 (Conv2D)  60          (None, 13, 13, 256)  131072      tf_op_layer_LeakyRelu_14[0][0]
__________________________________________________________________________________________________
batch_normalization_15 (BatchNo (None, 13, 13, 256)  1024        conv2d_15[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_15 (Tenso [(None, 13, 13, 256) 0           batch_normalization_15[0][0]
__________________________________________________________________________________________________
conv2d_18 (Conv2D)  63          (None, 13, 13, 128)  32768       tf_op_layer_LeakyRelu_15[0][0]
__________________________________________________________________________________________________
batch_normalization_17 (BatchNo (None, 13, 13, 128)  512         conv2d_18[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_17 (Tenso [(None, 13, 13, 128) 0           batch_normalization_17[0][0]
__________________________________________________________________________________________________
tf_op_layer_ResizeBilinear (Ten [(None, 26, 26, 128) 0           tf_op_layer_LeakyRelu_17[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_6 (TensorFlo [(None, 26, 26, 384) 0           tf_op_layer_ResizeBilinear[0][0]
                                                                 tf_op_layer_LeakyRelu_13[0][0]
__________________________________________________________________________________________________
conv2d_19 (Conv2D) 68           (None, 26, 26, 256)  884736      tf_op_layer_concat_6[0][0]
__________________________________________________________________________________________________
conv2d_16 (Conv2D) 69           (None, 13, 13, 512)  1179648     tf_op_layer_LeakyRelu_15[0][0]
__________________________________________________________________________________________________
batch_normalization_18 (BatchNo (None, 26, 26, 256)  1024        conv2d_19[0][0]
__________________________________________________________________________________________________
batch_normalization_16 (BatchNo (None, 13, 13, 512)  2048        conv2d_16[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_18 (Tenso [(None, 26, 26, 256) 0           batch_normalization_18[0][0]
__________________________________________________________________________________________________
tf_op_layer_LeakyRelu_16 (Tenso [(None, 13, 13, 512) 0           batch_normalization_16[0][0]
__________________________________________________________________________________________________
conv2d_20 (Conv2D) 74           (None, 26, 26, 255)  65535       tf_op_layer_LeakyRelu_18[0][0]
__________________________________________________________________________________________________
conv2d_17 (Conv2D) 75           (None, 13, 13, 255)  130815      tf_op_layer_LeakyRelu_16[0][0]
__________________________________________________________________________________________________
tf_op_layer_Shape (TensorFlowOp [(4,)]               0           conv2d_20[0][0]
__________________________________________________________________________________________________
tf_op_layer_Shape_2 (TensorFlow [(4,)]               0           conv2d_17[0][0]
__________________________________________________________________________________________________
tf_op_layer_strided_slice (Tens [()]                 0           tf_op_layer_Shape[0][0]
__________________________________________________________________________________________________
tf_op_layer_strided_slice_2 (Te [()]                 0           tf_op_layer_Shape_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_Reshape/shape (Tens [(5,)]               0    80     tf_op_layer_strided_slice[0][0]
__________________________________________________________________________________________________
tf_op_layer_Reshape_1/shape (Te [(5,)]               0           tf_op_layer_strided_slice_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_Reshape (TensorFlow [(None, 26, 26, 3, 8 0           conv2d_20[0][0]
                                                                 tf_op_layer_Reshape/shape[0][0]
__________________________________________________________________________________________________
tf_op_layer_Reshape_1 (TensorFl [(None, 13, 13, 3, 8 0           conv2d_17[0][0]
                                                                 tf_op_layer_Reshape_1/shape[0][0]
__________________________________________________________________________________________________
tf_op_layer_Shape_1 (TensorFlow [(5,)]               0           tf_op_layer_Reshape[0][0]
__________________________________________________________________________________________________
tf_op_layer_Shape_3 (TensorFlow [(5,)]               0    85     tf_op_layer_Reshape_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_split_3 (TensorFlow [(None, 26, 26, 3, 2 0           tf_op_layer_Reshape[0][0]
__________________________________________________________________________________________________
tf_op_layer_strided_slice_1 (Te [()]                 0           tf_op_layer_Shape_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_split_4 (TensorFlow [(None, 13, 13, 3, 2 0           tf_op_layer_Reshape_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_strided_slice_3 (Te [()]                 0           tf_op_layer_Shape_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid (TensorFlow [(None, 26, 26, 3, 2 0    90     tf_op_layer_split_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_Tile/multiples (Ten [(5,)]               0           tf_op_layer_strided_slice_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid_3 (TensorFl [(None, 13, 13, 3, 2 0           tf_op_layer_split_4[0][0]
__________________________________________________________________________________________________
tf_op_layer_Tile_1/multiples (T [(5,)]               0           tf_op_layer_strided_slice_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_Mul (TensorFlowOpLa [(None, 26, 26, 3, 2 0           tf_op_layer_Sigmoid[0][0]
__________________________________________________________________________________________________
tf_op_layer_Tile (TensorFlowOpL [(None, 26, 26, 3, 2 0    95     tf_op_layer_Tile/multiples[0][0]
__________________________________________________________________________________________________
tf_op_layer_Mul_3 (TensorFlowOp [(None, 13, 13, 3, 2 0           tf_op_layer_Sigmoid_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_Tile_1 (TensorFlowO [(None, 13, 13, 3, 2 0           tf_op_layer_Tile_1/multiples[0][0
__________________________________________________________________________________________________
tf_op_layer_Sub (TensorFlowOpLa [(None, 26, 26, 3, 2 0           tf_op_layer_Mul[0][0]
__________________________________________________________________________________________________
tf_op_layer_Cast (TensorFlowOpL [(None, 26, 26, 3, 2 0           tf_op_layer_Tile[0][0]
__________________________________________________________________________________________________
tf_op_layer_Sub_1 (TensorFlowOp [(None, 13, 13, 3, 2 0   100     tf_op_layer_Mul_3[0][0]
__________________________________________________________________________________________________
tf_op_layer_Cast_1 (TensorFlowO [(None, 13, 13, 3, 2 0           tf_op_layer_Tile_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_AddV2 (TensorFlowOp [(None, 26, 26, 3, 2 0           tf_op_layer_Sub[0][0]
                                                                 tf_op_layer_Cast[0][0]
__________________________________________________________________________________________________
tf_op_layer_Exp (TensorFlowOpLa [(None, 26, 26, 3, 2 0           tf_op_layer_split_3[0][1]
__________________________________________________________________________________________________
tf_op_layer_AddV2_1 (TensorFlow [(None, 13, 13, 3, 2 0           tf_op_layer_Sub_1[0][0]
                                                                 tf_op_layer_Cast_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_Exp_1 (TensorFlowOp [(None, 13, 13, 3, 2 0   105     tf_op_layer_split_4[0][1]
__________________________________________________________________________________________________
tf_op_layer_Mul_1 (TensorFlowOp [(None, 26, 26, 3, 2 0           tf_op_layer_AddV2[0][0]
__________________________________________________________________________________________________
tf_op_layer_Mul_2 (TensorFlowOp [(None, 26, 26, 3, 2 0           tf_op_layer_Exp[0][0]
__________________________________________________________________________________________________
tf_op_layer_Mul_4 (TensorFlowOp [(None, 13, 13, 3, 2 0           tf_op_layer_AddV2_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_Mul_5 (TensorFlowOp [(None, 13, 13, 3, 2 0           tf_op_layer_Exp_1[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_7 (TensorFlo [(None, 26, 26, 3, 4 0   110     tf_op_layer_Mul_1[0][0]
                                                                 tf_op_layer_Mul_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid_1 (TensorFl [(None, 26, 26, 3, 1 0           tf_op_layer_split_3[0][2]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid_2 (TensorFl [(None, 26, 26, 3, 8 0           tf_op_layer_split_3[0][3]
__________________________________________________________________________________________________
tf_op_layer_concat_9 (TensorFlo [(None, 13, 13, 3, 4 0           tf_op_layer_Mul_4[0][0]
                                                                 tf_op_layer_Mul_5[0][0]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid_4 (TensorFl [(None, 13, 13, 3, 1 0           tf_op_layer_split_4[0][2]
__________________________________________________________________________________________________
tf_op_layer_Sigmoid_5 (TensorFl [(None, 13, 13, 3, 8 0   115     tf_op_layer_split_4[0][3]
__________________________________________________________________________________________________
tf_op_layer_concat_8 (TensorFlo [(None, 26, 26, 3, 8 0           tf_op_layer_concat_7[0][0]
                                                                 tf_op_layer_Sigmoid_1[0][0]
                                                                 tf_op_layer_Sigmoid_2[0][0]
__________________________________________________________________________________________________
tf_op_layer_concat_10 (TensorFl [(None, 13, 13, 3, 8 0           tf_op_layer_concat_9[0][0]
                                                                 tf_op_layer_Sigmoid_4[0][0]
                                                                 tf_op_layer_Sigmoid_5[0][0]
==================================================================================================
Total params: 6,062,814
Trainable params: 6,056,606
Non-trainable params: 6,208
__________________________________________________________________________________________________

Weights:

    0 (3, 3, 3, 32) w0 864
    1 (32,) w0n
    2 (32,)
    3 (32,)
    4 (32,)
    5 (3, 3, 32, 64) w1 18432
    6 (64,) w1n
    7 (64,)
    8 (64,)
    9 (64,)
    10 (3, 3, 64, 64) w2 36864
    11 (64,) w2n
    12 (64,)
    13 (64,)
    14 (64,)
    15 (3, 3, 32, 32) w3 9216
    16 (32,) w3n
    17 (32,)
    18 (32,)
    19 (32,)
    20 (3, 3, 32, 32) w4 9216
    21 (32,) w4n
    22 (32,)
    23 (32,)
    24 (32,)
    25 (1, 1, 64, 64) w5 4096
    26 (64,) w5n
    27 (64,)
    28 (64,)
    29 (64,)
    30 (3, 3, 128, 128) w6 147456
    31 (128,) w6n
    32 (128,)
    33 (128,)
    34 (128,)
    35 (3, 3, 64, 64) w7 36864
    36 (64,) w7n
    37 (64,)
    38 (64,)
    39 (64,)
    40 (3, 3, 64, 64) w8 36864
    41 (64,) w8n
    42 (64,)
    43 (64,)
    44 (64,)
    45 (1, 1, 128, 128) w9 16384
    46 (128,) w9n
    47 (128,)
    48 (128,)
    49 (128,)
    50 (3, 3, 256, 256) w10 589824
    51 (256,) w10n
    52 (256,)
    53 (256,)
    54 (256,)
    55 (3, 3, 128, 128) w11 147456
    56 (128,) w11n
    57 (128,)
    58 (128,)
    59 (128,)
    60 (3, 3, 128, 128) w12 147456
    61 (128,) w12n
    62 (128,)
    63 (128,)
    64 (128,)
    65 (1, 1, 256, 256) w13 65536
    66 (256,) w13n
    67 (256,)
    68 (256,)
    69 (256,)
    70 (3, 3, 512, 512) w14 2359296
    71 (512,) w14n
    72 (512,)
    73 (512,)
    74 (512,)
    75 (1, 1, 512, 256) w15 131072
    76 (256,) w15n
    77 (256,)
    78 (256,)
    79 (256,)
    80 (1, 1, 256, 128) w18 32768
    81 (128,) w18n
    82 (128,)
    83 (128,)
    84 (128,)
    85 (3, 3, 384, 256) w19 884736
    86 (3, 3, 256, 512) w16 1179648
    87 (256,) w19n
    88 (256,)
    89 (256,)
    90 (256,)
    91 (512,) w16n
    92 (512,)
    93 (512,)
    94 (512,)
    95 (1, 1, 256, 255) w20 65280
    96 (255,) w20b
    97 (1, 1, 512, 255) w17 130560
    98 (255,) w17b

*/

#include <stdlib.h>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <random>
#include <fstream>
#include <iostream>
#include <thread>
#include <vector>

using namespace std;
using namespace cv;
using namespace cv::ml;

class yolov4tiny
{
private:

    float eps;
    float alpha;

    const float anchors[2][3][2] =
    {
        23,27,
        37,58,
        81,82,

        81,82,
        135,169,
        344,319
    };

    // weights
    float**** w0, **** w1, **** w2, **** w3, **** w4, **** w5, **** w6, **** w7, **** w8, **** w9,
        **** w10, **** w11, **** w12, **** w13, **** w14, **** w15, **** w16, **** w17, **** w18,
        **** w19, **** w20;
    // batch norm
    float** w0n, ** w1n, ** w2n, ** w3n, ** w4n, ** w5n, ** w6n, ** w7n, ** w8n, ** w9n, ** w10n, ** w11n,
        ** w12n, ** w13n, ** w14n, ** w15n, ** w16n, ** w19n, ** w18n;
    // bias
    float* w20b, * w17b;

    // layers
    float*** image;
    float*** l0, *** l1, *** l2, *** l3, *** l4, *** l5, *** l6, *** l7, *** l8, *** l9, *** l10, *** l11,
        *** l12, *** l13, *** l14, *** l15, *** l16, *** l17, *** l18, *** l19, *** l20;
    // concat layers
    float*** l5c52, *** l9c96, *** l13c1310, *** l18bu;

    float**** getWeights(ifstream* fin, int mi, int mj, int mk, int ml)
    {
        float**** buff = (float****)createArray(mi, mj, mk, ml, sizeof(float));
        for (int i = 0; i < mi; i++) {
            for (int j = 0; j < mj; j++) {
                for (int k = 0; k < mk; k++) {
                    fin->read(reinterpret_cast<char*>(buff[i][j][k]), sizeof(float) * ml);
                }
            }
        }
        return buff;
    }

    float** getNorm(ifstream* fin, int mj)
    {
        float** buff = (float**)createArray(4, mj, sizeof(float));
        for (int i = 0; i < 4; i++) {
            fin->read(reinterpret_cast<char*>(buff[i]), sizeof(float) * mj);
        }
        return buff;
    }

    float* getBias(ifstream* fin, int mi)
    {
        float* buff = (float*)malloc(mi * sizeof(float));
        fin->read(reinterpret_cast<char*>(buff), sizeof(float) * mi);
        return buff;
    }

    inline float batchNorm(float x, float gamma, float beta, float mean, float var)
    {
        //z1_hat = (x - pop_mean) / sqrt(pop_var + epsilon)
        //  BN1 = gamma * z1_hat + beta
        return ((x - mean) / sqrtf(var + eps)) * gamma + beta;
    }

    inline float leaky(float x)
    {
        return x < 0 ? alpha * x : x;
    }

    inline float sigmoid(float x)
    {
        return 1.0f / (1.0f + expf(-x));
    }

    inline float padLayerUneven(float*** layer, uint x, uint y, uint z)
    {
        if (x == 0 || y == 0) return 0.0f;
        return layer[x - 1][y - 1][z];
    }

    inline float padLayerEven(float*** layer, uint x, uint y, uint z, uint xm, uint ym)
    {
        if (x == 0 || y == 0 || x > xm || y > ym) return 0.0f;
        return layer[x - 1][y - 1][z];
    }

    inline float lerp(float a, float b, float f)
    {
        return a + f * (b - a);
    }

    inline float frac(float v)
    {
        return v - floorf(v);
    }

    inline float decode4to3(float*** cl, uint x, uint y, uint z, uint w)
    {
        return cl[x][y][z * 85 + w];
    }

public:
    // Annoying mallocs
    static float** createArray(int i, int j, size_t size)
    {
        float** r = new float* [i * sizeof(float*)];
        for (int x = 0; x < i; x++) {
            r[x] = new float[j * size];
        }
        return r;
    }

    static float*** createArray(int i, int j, int k, size_t size)
    {
        float*** r = new float** [i * sizeof(float*)];
        for (int x = 0; x < i; x++) {
            r[x] = new float* [j * sizeof(float*)];
            for (int y = 0; y < j; y++) {
                r[x][y] = new float[k * size];
            }
        }
        return r;
    }

    static float**** createArray(int i, int j, int k, int l, size_t size)
    {
        float**** r = new float*** [i * sizeof(float*)];
        for (int x = 0; x < i; x++) {
            r[x] = new float** [j * sizeof(float*)];
            for (int y = 0; y < j; y++) {
                r[x][y] = new float* [k * sizeof(float*)];
                for (int z = 0; z < k; z++) {
                    r[x][y][z] = new float[l * size];
                }
            }
        }
        return r;
    }

    // Annoying malloc frees
    static void freeArray(int i, float* a)
    {
        delete[] a;
    }

    static void freeArray(int i, int j, float** a)
    {
        for (int x = 0; x < i; x++) {
            delete[] a[x];
        }
        delete[] a;
    }

    static void freeArray(int i, int j, int k, float*** a)
    {
        for (int x = 0; x < i; x++) {
            for (int y = 0; y < j; y++) {
                delete[] a[x][y];
            }
            delete[] a[x];
        }
        delete[] a;
    }

    static void freeArray(int i, int j, int k, int l, float**** a)
    {
        for (int x = 0; x < i; x++) {
            for (int y = 0; y < j; y++) {
                for (int z = 0; z < k; z++) {
                    delete[] a[x][y][z];
                }
                delete[] a[x][y];
            }
            delete[] a[x];
        }
        delete[] a;
    }


    yolov4tiny(string path, float epsIn, float alphaIn)
    {
        eps = epsIn;
        alpha = alphaIn;

        ifstream fin(path, ios::binary);
        if (!fin) {
            cout << "error opening stream" << endl;
            exit(-1);
        }

        w0 = getWeights(&fin, 3, 3, 3, 32);
        w0n = getNorm(&fin, 32);
        w1 = getWeights(&fin, 3, 3, 32, 64);
        w1n = getNorm(&fin, 64);
        w2 = getWeights(&fin, 3, 3, 64, 64);
        w2n = getNorm(&fin, 64);
        w3 = getWeights(&fin, 3, 3, 32, 32);
        w3n = getNorm(&fin, 32);
        w4 = getWeights(&fin, 3, 3, 32, 32);
        w4n = getNorm(&fin, 32);
        w5 = getWeights(&fin, 1, 1, 64, 64);
        w5n = getNorm(&fin, 64);
        w6 = getWeights(&fin, 3, 3, 128, 128);
        w6n = getNorm(&fin, 128);
        w7 = getWeights(&fin, 3, 3, 64, 64);
        w7n = getNorm(&fin, 64);
        w8 = getWeights(&fin, 3, 3, 64, 64);
        w8n = getNorm(&fin, 64);
        w9 = getWeights(&fin, 1, 1, 128, 128);
        w9n = getNorm(&fin, 128);
        w10 = getWeights(&fin, 3, 3, 256, 256);
        w10n = getNorm(&fin, 256);
        w11 = getWeights(&fin, 3, 3, 128, 128);
        w11n = getNorm(&fin, 128);
        w12 = getWeights(&fin, 3, 3, 128, 128);
        w12n = getNorm(&fin, 128);
        w13 = getWeights(&fin, 1, 1, 256, 256);
        w13n = getNorm(&fin, 256);
        w14 = getWeights(&fin, 3, 3, 512, 512);
        w14n = getNorm(&fin, 512);
        w15 = getWeights(&fin, 1, 1, 512, 256);
        w15n = getNorm(&fin, 256);
        w18 = getWeights(&fin, 1, 1, 256, 128);
        w18n = getNorm(&fin, 128);
        w19 = getWeights(&fin, 3, 3, 384, 256);
        w16 = getWeights(&fin, 3, 3, 256, 512);
        w19n = getNorm(&fin, 256);
        w16n = getNorm(&fin, 512);
        w20 = getWeights(&fin, 1, 1, 256, 255);
        w20b = getBias(&fin, 255);
        w17 = getWeights(&fin, 1, 1, 512, 255);
        w17b = getBias(&fin, 255);

        fin.close();

        l0 = (float***)createArray(208, 208, 32, sizeof(float));
        l1 = (float***)createArray(104, 104, 64, sizeof(float));
        l2 = (float***)createArray(104, 104, 64, sizeof(float));
        l3 = (float***)createArray(104, 104, 32, sizeof(float));
        l4 = (float***)createArray(104, 104, 32, sizeof(float));
        l5 = (float***)createArray(104, 104, 64, sizeof(float));
        l6 = (float***)createArray(52, 52, 128, sizeof(float));
        l7 = (float***)createArray(52, 52, 64, sizeof(float));
        l8 = (float***)createArray(52, 52, 64, sizeof(float));
        l9 = (float***)createArray(52, 52, 128, sizeof(float));
        l10 = (float***)createArray(26, 26, 256, sizeof(float));
        l11 = (float***)createArray(26, 26, 128, sizeof(float));
        l12 = (float***)createArray(26, 26, 128, sizeof(float));
        l13 = (float***)createArray(26, 26, 256, sizeof(float));
        l14 = (float***)createArray(13, 13, 512, sizeof(float));
        l15 = (float***)createArray(13, 13, 256, sizeof(float));
        l18 = (float***)createArray(13, 13, 128, sizeof(float));
        l19 = (float***)createArray(26, 26, 256, sizeof(float));
        l16 = (float***)createArray(13, 13, 512, sizeof(float));
        l20 = (float***)createArray(26, 26, 255, sizeof(float));
        l17 = (float***)createArray(13, 13, 255, sizeof(float));

        l5c52 = (float***)createArray(52, 52, 128, sizeof(float));
        l9c96 = (float***)createArray(26, 26, 256, sizeof(float));
        l13c1310 = (float***)createArray(13, 13, 512, sizeof(float));
        l18bu = (float***)createArray(26, 26, 128, sizeof(float));

        //ifstream flin("D:\\Storage\\Unity\\yolov4-tiny\\data\\L66Out.bin", ios::binary);
        //if (!flin) {
        //    cout << "error opening stream" << endl;
        //    exit(-1);
        //}

        //for (int i = 0; i < 26; i++) {
        //    for (int j = 0; j < 26; j++) {
        //        flin.read(reinterpret_cast<char*>(l18bu[i][j]), sizeof(float) * 128);
        //    }
        //}
    }

    ~yolov4tiny()
    {
        freeArray(208, 128, 64, l0);
        freeArray(104, 104, 64, l1);
        freeArray(104, 104, 64, l2);
        freeArray(104, 104, 32, l3);
        freeArray(104, 104, 32, l4);
        freeArray(104, 104, 64, l5);
        freeArray(52, 52, 128, l6);
        freeArray(52, 52, 64, l7);
        freeArray(52, 52, 64, l8);
        freeArray(52, 52, 128, l9);
        freeArray(26, 26, 256, l10);
        freeArray(26, 26, 128, l11);
        freeArray(26, 26, 128, l12);
        freeArray(26, 26, 256, l13);
        freeArray(13, 13, 512, l14);
        freeArray(13, 13, 256, l15);
        freeArray(13, 13, 512, l16);
        freeArray(13, 13, 255, l17);
        freeArray(13, 13, 128, l18);
        freeArray(26, 26, 256, l19);
        freeArray(26, 26, 255, l20);

        freeArray(52, 52, 128, l5c52);
        freeArray(26, 26, 256, l9c96);
        freeArray(13, 13, 512, l13c1310);
        freeArray(26, 26, 128, l18bu);

        freeArray(3, 3, 3, 32, w0);
        freeArray(3, 3, 32, 64, w1);
        freeArray(3, 3, 64, 64, w2);
        freeArray(3, 3, 32, 32, w3);
        freeArray(3, 3, 32, 32, w4);
        freeArray(1, 1, 64, 64, w5);
        freeArray(3, 3, 128, 128, w6);
        freeArray(3, 3, 64, 64, w7);
        freeArray(3, 3, 64, 64, w8);
        freeArray(1, 1, 128, 128, w9);
        freeArray(3, 3, 256, 256, w10);
        freeArray(3, 3, 128, 128, w11);
        freeArray(3, 3, 128, 128, w12);
        freeArray(1, 1, 256, 256, w13);
        freeArray(3, 3, 512, 512, w14);
        freeArray(1, 1, 512, 256, w15);
        freeArray(1, 1, 256, 128, w18);
        freeArray(3, 3, 384, 256, w19);
        freeArray(3, 3, 256, 512, w16);
        freeArray(1, 1, 256, 255, w20);
        freeArray(1, 1, 512, 255, w17);

        freeArray(4, 32, w0n);
        freeArray(4, 64, w1n);
        freeArray(4, 64, w2n);
        freeArray(4, 32, w3n);
        freeArray(4, 32, w4n);
        freeArray(4, 64, w5n);
        freeArray(4, 128, w6n);
        freeArray(4, 64, w7n);
        freeArray(4, 64, w8n);
        freeArray(4, 128, w9n);
        freeArray(4, 256, w10n);
        freeArray(4, 128, w11n);
        freeArray(4, 128, w12n);
        freeArray(4, 256, w13n);
        freeArray(4, 512, w14n);
        freeArray(4, 256, w15n);
        freeArray(4, 128, w18n);
        freeArray(4, 256, w19n);
        freeArray(4, 512, w16n);

        delete [] w17b;
        delete[] w20b;
    }

    // Using seperate methods for each layer easier to debug
    void kernelFuncPaddedUnevenL0(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i * 2, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j * 2, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerUneven(pl, i0, j0, l) * cw[0][0][l][k] +
                        padLayerUneven(pl, i0, j1, l) * cw[0][1][l][k] +
                        padLayerUneven(pl, i0, j2, l) * cw[0][2][l][k] +
                        padLayerUneven(pl, i1, j0, l) * cw[1][0][l][k] +
                        padLayerUneven(pl, i1, j1, l) * cw[1][1][l][k] +
                        padLayerUneven(pl, i1, j2, l) * cw[1][2][l][k] +
                        padLayerUneven(pl, i2, j0, l) * cw[2][0][l][k] +
                        padLayerUneven(pl, i2, j1, l) * cw[2][1][l][k] +
                        padLayerUneven(pl, i2, j2, l) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedUnevenL1(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i * 2, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j * 2, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerUneven(pl, i0, j0, l) * cw[0][0][l][k] +
                        padLayerUneven(pl, i0, j1, l) * cw[0][1][l][k] +
                        padLayerUneven(pl, i0, j2, l) * cw[0][2][l][k] +
                        padLayerUneven(pl, i1, j0, l) * cw[1][0][l][k] +
                        padLayerUneven(pl, i1, j1, l) * cw[1][1][l][k] +
                        padLayerUneven(pl, i1, j2, l) * cw[1][2][l][k] +
                        padLayerUneven(pl, i2, j0, l) * cw[2][0][l][k] +
                        padLayerUneven(pl, i2, j1, l) * cw[2][1][l][k] +
                        padLayerUneven(pl, i2, j2, l) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL2(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL3(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm, uint loff)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, loff + l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, loff + l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, loff + l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, loff + l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, loff + l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, loff + l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, loff + l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, loff + l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, loff + l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL4(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL5(float*** cl, float** cn, float**** cw,
        float*** pl, float*** pl2, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                uint lh = lm / 2;
                for (uint l = 0; l < lh; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                for (uint l = lh; l < lm; l++) {
                    cl[i][j][k] += pl2[i][j][l - lh] * cw[0][0][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void concatMaxpoolL5(float*** cl, float*** pl, float*** pl2, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                uint i0 = i * 2, i1 = i0 + 1;
                uint j0 = j * 2, j1 = j0 + 1;

                float*** px = k < 64 ? pl2 : pl;
                uint kn = k % 64;
                cl[i][j][k] = fmaxf(fmaxf(fmaxf(px[i0][j0][kn], px[i0][j1][kn]),
                    px[i1][j0][kn]), px[i1][j1][kn]);
            }
        }
    }

    void kernelFuncPaddedEvenL6(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL7(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm, uint loff)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, loff + l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, loff + l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, loff + l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, loff + l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, loff + l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, loff + l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, loff + l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, loff + l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, loff + l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL8(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL9(float*** cl, float** cn, float**** cw,
        float*** pl, float*** pl2, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                uint lh = lm / 2;
                for (uint l = 0; l < lh; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                for (uint l = lh; l < lm; l++) {
                    cl[i][j][k] += pl2[i][j][l - lh] * cw[0][0][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void concatMaxpoolL9(float*** cl, float*** pl, float*** pl2, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                uint i0 = i * 2, i1 = i0 + 1;
                uint j0 = j * 2, j1 = j0 + 1;

                float*** px = k < 128 ? pl2 : pl;
                uint kn = k % 128;
                cl[i][j][k] = fmaxf(fmaxf(fmaxf(px[i0][j0][kn], px[i0][j1][kn]),
                    px[i1][j0][kn]), px[i1][j1][kn]);
            }
        }
    }

    void kernelFuncPaddedEvenL10(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL11(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm, uint loff)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, loff + l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, loff + l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, loff + l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, loff + l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, loff + l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, loff + l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, loff + l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, loff + l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, loff + l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL12(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL13(float*** cl, float** cn, float**** cw,
        float*** pl, float*** pl2, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                uint lh = lm / 2;
                for (uint l = 0; l < lh; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                for (uint l = lh; l < lm; l++) {
                    cl[i][j][k] += pl2[i][j][l - lh] * cw[0][0][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void concatMaxpoolL13(float*** cl, float*** pl, float*** pl2, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                uint i0 = i * 2, i1 = i0 + 1;
                uint j0 = j * 2, j1 = j0 + 1;

                float*** px = k < 256 ? pl2 : pl;
                uint kn = k % 256;
                cl[i][j][k] = fmaxf(fmaxf(fmaxf(px[i0][j0][kn], px[i0][j1][kn]),
                    px[i1][j0][kn]), px[i1][j1][kn]);
            }
        }
    }

    void kernelFuncPaddedEvenL14(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL15(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL18(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    // NOTE: Tensorflows implementation is different
    void bilinearUpscaleL18(float*** cl, float*** pl, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                float ii = i / float(im - 1);
                float jj = j / float(jm - 1);
                float pli = ii * float(im / 2 - 1);
                float plj = jj * float(jm / 2 - 1);
                float fpli = frac(pli);
                float fplj = frac(plj);
                uint pi0 = (unsigned int)floorf(pli);
                uint pj0 = (unsigned int)floorf(plj);
                uint pi1 = (unsigned int)ceilf(pli);
                uint pj1 = (unsigned int)ceilf(plj);
                float aa = pl[pi0][pj0][k];
                float ab = pl[pi0][pj1][k];
                float ba = pl[pi1][pj0][k];
                float bb = pl[pi1][pj1][k];
                float ta = lerp(aa, ba, fpli);
                float tb = lerp(ab, bb, fpli);
                cl[i][j][k] = lerp(ta, tb, fplj);
            }
        }
    }

    void kernelFuncPaddedEvenL19(float*** cl, float** cn, float**** cw,
        float*** pl, float*** pl2, uint im, uint jm, uint k, uint lm, uint lspl)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lspl; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                for (uint l = lspl; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl2, i0, j0, l - lspl, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl2, i0, j1, l - lspl, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl2, i0, j2, l - lspl, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl2, i1, j0, l - lspl, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl2, i1, j1, l - lspl, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl2, i1, j2, l - lspl, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl2, i2, j0, l - lspl, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl2, i2, j1, l - lspl, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl2, i2, j2, l - lspl, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL16(float*** cl, float** cn, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                uint i0 = i, i1 = i0 + 1, i2 = i0 + 2;
                uint j0 = j, j1 = j0 + 1, j2 = j0 + 2;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] +=
                        padLayerEven(pl, i0, j0, l, im, jm) * cw[0][0][l][k] +
                        padLayerEven(pl, i0, j1, l, im, jm) * cw[0][1][l][k] +
                        padLayerEven(pl, i0, j2, l, im, jm) * cw[0][2][l][k] +
                        padLayerEven(pl, i1, j0, l, im, jm) * cw[1][0][l][k] +
                        padLayerEven(pl, i1, j1, l, im, jm) * cw[1][1][l][k] +
                        padLayerEven(pl, i1, j2, l, im, jm) * cw[1][2][l][k] +
                        padLayerEven(pl, i2, j0, l, im, jm) * cw[2][0][l][k] +
                        padLayerEven(pl, i2, j1, l, im, jm) * cw[2][1][l][k] +
                        padLayerEven(pl, i2, j2, l, im, jm) * cw[2][2][l][k];
                }
                // batch norm
                cl[i][j][k] = batchNorm(cl[i][j][k], cn[0][k], cn[1][k], cn[2][k], cn[3][k]);
                // activation
                cl[i][j][k] = leaky(cl[i][j][k]);
            }
        }
    }

    void kernelFuncPaddedEvenL20(float*** cl, float* cb, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                // bias
                cl[i][j][k] += cb[k];
            }
        }
    }

    void kernelFuncPaddedEvenL17(float*** cl, float* cb, float**** cw,
        float*** pl, uint im, uint jm, uint k, uint lm)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                cl[i][j][k] = 0.0f;
                // kernel
                for (uint l = 0; l < lm; l++) {
                    cl[i][j][k] += pl[i][j][l] * cw[0][0][l][k];
                }
                // bias
                cl[i][j][k] += cb[k];
            }
        }
    }

    void decodeL20(float*** cl, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                uint l = k / 85;
                uint m = k % 85;
                bool scale = m < 2;
                bool sigmoidOrExp = scale || m >= 4;
                float grid = m % 2 == 0 ? float(j) : float(i);
                cl[i][j][k] = sigmoidOrExp ? sigmoid(cl[i][j][k]) : (expf(cl[i][j][k]) * anchors[0][l][m - 2]);
                cl[i][j][k] = scale ? ((cl[i][j][k] * 1.05f - 0.025f + grid) * 16.0f) : cl[i][j][k];
            }
        }
    }

    void decodeL17(float*** cl, uint im, uint jm, uint k)
    {
        for (uint i = 0; i < im; i++) {
            for (uint j = 0; j < jm; j++) {
                uint l = k / 85;
                uint m = k % 85;
                bool scale = m < 2;
                bool sigmoidOrExp = scale || m >= 4;
                float grid = m % 2 == 0 ? float(j) : float(i);
                cl[i][j][k] = sigmoidOrExp ? sigmoid(cl[i][j][k]) : (expf(cl[i][j][k]) * anchors[1][l][m - 2]);
                cl[i][j][k] = scale ? ((cl[i][j][k] * 1.05f - 0.025f + grid) * 32.0f) : cl[i][j][k];
            }
        }
    }

    void forwardProp(float*** img)
    {
        image = img;

        // do stuff faster
        vector<thread> threads;

        // L0, kernel=3x3, stride=2, padding=valid
        for (uint k = 0; k < 32; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedUnevenL0, this, l0, w0n, w0, image, 208, 208, k, 3);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L1, kernel=3x3, stride=2, padding=valid
        for (uint k = 0; k < 64; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedUnevenL1, this, l1, w1n, w1, l0, 104, 104, k, 32);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L2, kernel=3x3, stride=1, padding=same
        // L2 output is split into two 104 x 104 x 32
        for (uint k = 0; k < 64; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL2, this, l2, w2n, w2, l1, 104, 104, k, 64);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L3, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 32; k++) {
            // Apply kernel to only the last 32 layers of L2
            thread t(&yolov4tiny::kernelFuncPaddedEvenL3, this, l3, w3n, w3, l2, 104, 104, k, 32, 32);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L4, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 32; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL4, this, l4, w4n, w4, l3, 104, 104, k, 32);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L5, kernel=1x1, stride=1, padding=none
        // concat l4 and l3
        for (uint k = 0; k < 64; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL5, this, l5, w5n, w5, l4, l3, 104, 104, k, 64);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L5, concat, maxpool=2x2, stride=1
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::concatMaxpoolL5, this, l5c52, l5, l2, 52, 52, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L6, kernel=3x3, stride=1, padding=same
        // L6 output is split into two 52 x 52 x 64
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL6, this, l6, w6n, w6, l5c52, 52, 52, k, 128);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L7, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 64; k++) {
            // Apply kernel to only the last 64 layers of L6
            thread t(&yolov4tiny::kernelFuncPaddedEvenL7, this, l7, w7n, w7, l6, 52, 52, k, 64, 64);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L8, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 64; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL8, this, l8, w8n, w8, l7, 52, 52, k, 64);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L9, kernel=1x1, stride=1, padding=none
        // concat l8 and l7
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL9, this, l9, w9n, w9, l8, l7, 52, 52, k, 128);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L9, concat, maxpool=2x2, stride=1
        for (uint k = 0; k < 256; k++) {
            thread t(&yolov4tiny::concatMaxpoolL9, this, l9c96, l9, l6, 26, 26, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L10, kernel=3x3, stride=1, padding=same
        // L10 output is split into two 26 x 26 x 128
        for (uint k = 0; k < 256; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL10, this, l10, w10n, w10, l9c96, 26, 26, k, 256);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L11, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 128; k++) {
            // Apply kernel to only the last 128 layers of L10
            thread t(&yolov4tiny::kernelFuncPaddedEvenL11, this, l11, w11n, w11, l10, 26, 26, k, 128, 128);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L12, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL12, this, l12, w12n, w12, l11, 26, 26, k, 128);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L13, kernel=1x1, stride=1, padding=none
        // concat l12 and l11
        for (uint k = 0; k < 256; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL13, this, l13, w13n, w13, l12, l11, 26, 26, k, 256);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L13, concat, maxpool=2x2, stride=1
        for (uint k = 0; k < 512; k++) {
            thread t(&yolov4tiny::concatMaxpoolL13, this, l13c1310, l13, l10, 13, 13, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L14, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 512; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL14, this, l14, w14n, w14, l13c1310, 13, 13, k, 512);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L15, kernel=1x1, stride=1, padding=none
        for (uint k = 0; k < 256; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL15, this, l15, w15n, w15, l14, 13, 13, k, 512);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L18, kernel=1x1, stride=1, padding=none
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL18, this, l18, w18n, w18, l15, 13, 13, k, 256);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L18, bilinear upscale
        for (uint k = 0; k < 128; k++) {
            thread t(&yolov4tiny::bilinearUpscaleL18, this, l18bu, l18, 26, 26, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L19, kernel=3x3, stride=1, padding=same
        // concat l18 and l3
        for (uint k = 0; k < 256; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL19, this, l19, w19n, w19, l18bu, l13, 26, 26, k, 384, 128);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L16, kernel=3x3, stride=1, padding=same
        for (uint k = 0; k < 512; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL16, this, l16, w16n, w16, l15, 13, 13, k, 256);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L20, kernel=1x1, stride=1, padding=none
        for (uint k = 0; k < 255; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL20, this, l20, w20b, w20, l19, 26, 26, k, 256);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // L17, kernel=1x1, stride=1, padding=none
        for (uint k = 0; k < 255; k++) {
            thread t(&yolov4tiny::kernelFuncPaddedEvenL17, this, l17, w17b, w17, l16, 13, 13, k, 512);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        // Decoding model output

        for (uint k = 0; k < 255; k++) {
            thread t(&yolov4tiny::decodeL20, this, l20, 26, 26, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        for (uint k = 0; k < 255; k++) {
            thread t(&yolov4tiny::decodeL17, this, l17, 13, 13, k);
            threads.push_back(move(t));
        }
        for (auto& th : threads) th.join();
        threads.clear();

        //cout << l17[12][5][88] << endl;
        //for (uint i = 0; i < 13; i++) {
        //    for (uint j = 0; j < 13; j++) {
        //        for (uint k = 0; k < 3; k++) {
        //            float conf = decode4to3(l17, i, j, k, 4);
        //            if (conf > 0.5)
        //                cout << conf << " " << i << " " << j << " " << k << " " << endl;
        //        }
        //    }
        //}
        //cout << decode4to3(l20, 12, 11, 2, 4) * 1000000 << endl;
        //cout << decode4to3(l17, 11, 8, 3, 83) << endl;
    }

    void drawBbox(Mat img)
    {
        float x_scale = img.cols / 416.0f;
        float y_scale = img.rows / 416.0f;

        for (uint i = 0; i < 13; i++) {
            for (uint j = 0; j < 13; j++) {
                for (uint k = 0; k < 3; k++) {
                    float x = decode4to3(l17, i, j, k, 0) * x_scale;
                    float y = decode4to3(l17, i, j, k, 1) * y_scale;
                    float w = decode4to3(l17, i, j, k, 2) * x_scale;
                    float h = decode4to3(l17, i, j, k, 3) * y_scale;
                    float conf = decode4to3(l17, i, j, k, 4);
                    if (conf > 0.5f) {
                        uint cls = 0;
                        float topPb = 0.0f;
                        for (uint l = 0; l < 80; l++) {
                            float prob = decode4to3(l17, i, j, k, l + 5);
                            if (prob > topPb)
                            {
                                cls = l;
                                topPb = prob;
                            }
                        }

                        Rect r = Rect(x - w * 0.5f, y - h * 0.5f, w, h);
                        rectangle(img, r, Scalar(255, 0, 0), (int)x_scale, 8, 0);

                        cout << "x: " << x << " y: " << y << " w: " << w << " h: " << h << endl;
                        cout << "class: " << cls << " prob: " << topPb << " conf: " << conf << endl;
                    }
                }
            }
        }

        for (uint i = 0; i < 26; i++) {
            for (uint j = 0; j < 26; j++) {
                for (uint k = 0; k < 3; k++) {
                    float x = decode4to3(l20, i, j, k, 0) * x_scale;
                    float y = decode4to3(l20, i, j, k, 1) * y_scale;
                    float w = decode4to3(l20, i, j, k, 2) * x_scale;
                    float h = decode4to3(l20, i, j, k, 3) * y_scale;
                    float conf = decode4to3(l20, i, j, k, 4);
                    if (conf > 0.5f) {
                        uint cls = 0;
                        float topPb = 0.0f;
                        for (uint l = 0; l < 80; l++) {
                            float prob = decode4to3(l20, i, j, k, l + 5);
                            if (prob > topPb)
                            {
                                cls = l;
                                topPb = prob;
                            }
                        }

                        Rect r = Rect(x - w * 0.5f, y - h * 0.5f, w, h);
                        rectangle(img, r, Scalar(255, 0, 0), (int)x_scale, 8, 0);

                        cout << "x: " << x << " y: " << y << " w: " << w << " h: " << h << endl;
                        cout << "class: " << cls << " prob: " << topPb << " conf: " << conf << endl;
                    }
                }
            }
        }
    }
};

int main() {

    Mat img;
    img = imread("D:\\Storage\\Unity\\yolov4-tiny\\data\\vrc.png");
    Mat org_img = img.clone();

    // opencv read stuff in BGR
    cvtColor(img, img, COLOR_BGR2RGB);
    resize(img, img, Size(416, 416), 0.0, 0.0, INTER_AREA);
    img.convertTo(img, CV_32FC3);
    // normalize values
    img = img / 255.0;

    // use a 3d array cause fuck opencv mats
    float*** imgArray = (float***)yolov4tiny::createArray(416, 416, 3, sizeof(float));
    for (int k = 0; k < 3; k++) {
        for (int i = 0; i < 416; i++) {
            for (int j = 0; j < 416; j++) {
                imgArray[i][j][k] = img.at<Vec3f>(i, j)[k];
            }
        }
    }

    //for (int k = 0; k < 3; k++) {
    //    for (int i = 0; i < 416; i++) {
    //        for (int j = 0; j < 416; j++) {
    //            if (k == 0) imgArray[i][j][k] = (i / 415.0f) * (j / 415.0f);
    //            else if (k == 1) imgArray[i][j][k] = ((415.0f - i) / 415.0f) * (j / 415.0f);
    //            else imgArray[i][j][k] = (i / 415.0f) * ((415.0f - j) / 415.0f);
    //        }
    //    }
    //}

    string PATH = "D:\\Storage\\Unity\\yolov4-tiny\\data\\yolov4-tiny.bytes";
    yolov4tiny yolo = yolov4tiny(PATH, 0.001f, 0.1f);
    yolo.forwardProp(imgArray);
    yolo.drawBbox(org_img);

    namedWindow("Display window", WINDOW_NORMAL);
    imshow("Display window", org_img);
    waitKey(0); // Wait for a keystroke in the window

    //cin.get();
    return 0;
};