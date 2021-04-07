#if UNITY_EDITOR

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEngine.UI;

[ExecuteInEditMode]
public class YOLOv4tinyWeights : EditorWindow
{
    public TextAsset source0;
    string SavePath;

    [MenuItem("Tools/SCRN/Bake YOLOv4tiny")]
    static void Init()
    {
        var window = GetWindowWithRect<YOLOv4tinyWeights>(new Rect(0, 0, 400, 250));
        window.Show();
    }
    
    void OnGUI()
    {
        GUILayout.Label("Bake YOLOv4tiny", EditorStyles.boldLabel);
        EditorGUILayout.BeginVertical();
        source0 = (TextAsset) EditorGUILayout.ObjectField("YOLOv4tiny Weights (.bytes):", source0, typeof(TextAsset), false);
        EditorGUILayout.EndVertical();

        if (GUILayout.Button("Bake!") && source0 != null) {
            string path = AssetDatabase.GetAssetPath(source0);
            int fileDir = path.LastIndexOf("/");
            SavePath = path.Substring(0, fileDir) + "/baked-weights.asset";
            OnGenerateTexture();
        }
    }

    void OnGenerateTexture()
    {
        const int width = 2048;
        const int height = 4096;
        Texture2D tex = new Texture2D(width, height, TextureFormat.RFloat, false);
        tex.wrapMode = TextureWrapMode.Clamp;
        tex.filterMode = FilterMode.Point;
        tex.anisoLevel = 1;
        
        ExtractFromBin(tex, source0);
        AssetDatabase.CreateAsset(tex, SavePath);
        AssetDatabase.SaveAssets();

        ShowNotification(new GUIContent("Done"));
    }

    void writeBlock(Texture2D tex, BinaryReader br0, int totalFloats, int destX, int destY, int width)
    {
        for (int i = 0; i < totalFloats; i++)
        {
            int x = i % width;
            int y = i / width;
            tex.SetPixel(x + destX, y + destY,
                new Color(br0.ReadSingle(), 0, 0, 0)); //br0.ReadSingle()
        }
    }

    void ExtractFromBin(Texture2D tex, TextAsset srcIn0)
    {
        Stream s0 = new MemoryStream(srcIn0.bytes);
        BinaryReader br0 = new BinaryReader(s0);

        writeBlock(tex, br0, 864 , 0 , 4068 , 96 ); // txW0
        writeBlock(tex, br0, 128 , 448 , 4060 , 32 ); // txWN0
        writeBlock(tex, br0, 18432 , 640 , 3792 , 256 ); // txW1
        writeBlock(tex, br0, 256 , 256 , 4060 , 64 ); // txWN1
        writeBlock(tex, br0, 36864 , 0 , 3904 , 256 ); // txW2
        writeBlock(tex, br0, 256 , 320 , 4060 , 64 ); // txWN2
        writeBlock(tex, br0, 9216 , 640 , 3992 , 128 ); // txW3
        writeBlock(tex, br0, 128 , 480 , 4060 , 32 ); // txWN3
        writeBlock(tex, br0, 9216 , 768 , 3864 , 128 ); // txW4
        writeBlock(tex, br0, 128 , 0 , 4077 , 32 ); // txWN4
        writeBlock(tex, br0, 4096 , 768 , 3936 , 64 ); // txW5
        writeBlock(tex, br0, 256 , 384 , 4056 , 64 ); // txWN5
        writeBlock(tex, br0, 147456 , 0 , 2304 , 512 ); // txW6
        writeBlock(tex, br0, 512 , 512 , 4048 , 128 ); // txWN6
        writeBlock(tex, br0, 36864 , 256 , 3904 , 256 ); // txW7
        writeBlock(tex, br0, 256 , 448 , 4056 , 64 ); // txWN7
        writeBlock(tex, br0, 36864 , 510 , 3648 , 256 ); // txW8
        writeBlock(tex, br0, 256 , 384 , 4060 , 64 ); // txWN8
        writeBlock(tex, br0, 16384 , 640 , 3864 , 128 ); // txW9
        writeBlock(tex, br0, 512 , 512 , 4052 , 128 ); // txWN9
        writeBlock(tex, br0, 589824 , 1024 , 2016 , 1024 ); // txW10
        writeBlock(tex, br0, 1024 , 0 , 4052 , 256 ); // txWN10
        writeBlock(tex, br0, 147456 , 512 , 2304 , 512 ); // txW11
        writeBlock(tex, br0, 512 , 512 , 4056 , 128 ); // txWN11
        writeBlock(tex, br0, 147456 , 0 , 2592 , 512 ); // txW12
        writeBlock(tex, br0, 512 , 512 , 4060 , 128 ); // txWN12
        writeBlock(tex, br0, 65536 , 255 , 3392 , 256 ); // txW13
        writeBlock(tex, br0, 1024 , 0 , 4056 , 256 ); // txWN13
        writeBlock(tex, br0, 2359296 , 0 , 0 , 2048 ); // txW14
        writeBlock(tex, br0, 2048 , 0 , 4064 , 512 ); // txWN14
        writeBlock(tex, br0, 131072 , 0 , 2880 , 256 ); // txW15
        writeBlock(tex, br0, 1024 , 0 , 4060 , 256 ); // txWN15
        writeBlock(tex, br0, 32768 , 512 , 3792 , 128 ); // txW18
        writeBlock(tex, br0, 512 , 256 , 4056 , 128 ); // txWN18
        writeBlock(tex, br0, 884736 , 1024 , 1152 , 1024 ); // txW19
        writeBlock(tex, br0, 1179648 , 0 , 1152 , 1024 ); // txW16
        writeBlock(tex, br0, 1024 , 256 , 4052 , 256 ); // txWN19
        writeBlock(tex, br0, 2048 , 0 , 4048 , 512 ); // txWN16
        writeBlock(tex, br0, 65280 , 255 , 3648 , 255 ); // txW20
        writeBlock(tex, br0, 255 , 256 , 2880 , 1 ); // txWB20
        writeBlock(tex, br0, 130560 , 0 , 3392 , 255 ); // txW17
        writeBlock(tex, br0, 255 , 256 , 3135 , 1 ); // txWB17
    }
}

#endif