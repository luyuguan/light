using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace light.unitypath
{
public class Path {

	public static string GetWWWStreamPath()
	{
		if (Application.platform == RuntimePlatform.Android) {
			return Application.streamingAssetsPath;
		} else if (Application.platform == RuntimePlatform.IPhonePlayer) {
			return "file://" + Application.streamingAssetsPath;
		} 
		return "file:///" + Application.streamingAssetsPath; //editor mode
	}

	public static string GetWWWPersistPath()
	{
		if (Application.platform == RuntimePlatform.Android
			|| Application.platform == RuntimePlatform.IPhonePlayer) {
			return "file://" + Application.persistentDataPath;
		} 
		//else if (Application.platform == RuntimePlatform.WindowsEditor) {
		return "file:///" + Application.persistentDataPath; //editor
		//}
	}

	public static string GetAssetStreamPath()
	{
		return Application.streamingAssetsPath;
	}

	public static string GetAssetPersistPath()
	{
		return Application.persistentDataPath;
	}


	public static string GetIOPersistPath()
	{
		return Application.persistentDataPath;
	}
}
}