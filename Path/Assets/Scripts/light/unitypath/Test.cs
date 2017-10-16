using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace light.unitypath
{
public class Test : MonoBehaviour {

	string debug = "";
	public	int height = 20;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void OnGUI()
		{
			if (GUILayout.Button ("WWWStreamTxt", GUILayout.Height (height))) {
				string www = Path.GetWWWStreamPath ();
				www += "/hello.txt";
				debug = www;
				StartCoroutine (WWWTxt (www));
			}

			if (GUILayout.Button ("WWWStreamBundle", GUILayout.Height (height))) {
				string www = Path.GetWWWStreamPath ();
				www += "/hello";
				debug = www;
				StartCoroutine (WWWBundle (www));
			}

			if (GUILayout.Button ("CreatePersistBundle", GUILayout.Height (height))) {
				string www = Path.GetWWWStreamPath ();
				www += "/hello";
				string outpath = Path.GetIOPersistPath ();
				outpath += "/hello";
				debug = www;
				debug += "\n" + outpath;
				StartCoroutine(CreatePersistBundle (www, outpath));
			}

//			if (GUILayout.Button ("WWWPesistTxt", GUILayout.Height (height))) {
//				string www = Path.GetWWWPersistPath ();
//				www += "/hello.txt";
//				debug = www;
//				StartCoroutine (WWWTxt (www));
//			}

			if (GUILayout.Button ("WWWPesistBundle", GUILayout.Height (height))) {
				string www = Path.GetWWWPersistPath ();
				www += "/hello";
				debug = www;
				StartCoroutine (WWWBundle (www));
			}

			if (GUILayout.Button ("AssetStreamBundle", GUILayout.Height (height))) {
				string path = Path.GetAssetStreamPath ();
				path += "/hello";
				debug = path;
				AssetRead (path);
			}

			if (GUILayout.Button ("AssetPersistBundle", GUILayout.Height (height))) {
				string path = Path.GetAssetPersistPath ();
				path += "/hello";
				debug = path;
				AssetRead (path);
			}

			GUILayout.Label (debug);
		}

	IEnumerator WWWTxt(string path)
	{
		WWW www = new WWW (path);
		yield return www;
		debug += "\n" + www.text;
	}

	IEnumerator WWWBundle(string path)
	{
		WWW www = new WWW (path);
		yield return www;
		string text = (www.assetBundle.LoadAsset("hello") as TextAsset).text;
		debug += "\n" + text;
		www.assetBundle.Unload (true);

	}

	IEnumerator CreatePersistBundle(string path, string outpath)
	{
		WWW www = new WWW (path);
		yield return www;
		System.IO.File.WriteAllBytes (outpath,www.bytes);
		debug += "\nwritedone";
	}

		void AssetRead(string path)
		{
			AssetBundle bundle = AssetBundle.LoadFromFile (path);
			string text = (bundle.LoadAsset("hello") as TextAsset).text;
			debug += "\n" + text;
			bundle.Unload (true);
		}
	}
}
