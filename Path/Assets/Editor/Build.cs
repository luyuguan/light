using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class Build {
	[MenuItem("Tool/Build")]
	public static void BuildAll()
	{
		//Debug.Log ("Application dataPath :" + Application.dataPath);
		BuildPipeline.BuildAssetBundles (Application.dataPath + "/../ab", BuildAssetBundleOptions.None, BuildTarget.Android);
	}
}
