Shader "surface/lambert_normal"
{
	Properties
	{
		_MainColor("Main Color(RGB)", Color) = (1,1,1,1)
		_MainTex("Main Texture(RGB)", 2D) = "white" {}
		_BumpTex("Bump", 2D) = "bump" {}
	}

	SubShader
	{
		Tags {"RenderType" = "Opacue"}
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _MainColor;
		sampler2D _MainTex;
		sampler2D _BumpTex;

		struct Input
		{
			half2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 col = tex2D(_MainTex, IN.uv_MainTex);
			col = col * _MainColor;
			o.Albedo = col.rgb;
			o.Alpha = 1;
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_MainTex));
		}
		ENDCG
	}

	Fallback "Diffuse"
}