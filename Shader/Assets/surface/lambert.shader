Shader "surface/lambert"
{
	Properties
	{
		_MainColor("Main Color(RGB)", Color) = (1,1,1,1)
		_MainTex("Main Texture(RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Tags {"RenderType" = "Opacue"}
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _MainColor;
		sampler2D _MainTex;

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
		}
		ENDCG
	}

	Fallback "Diffuse"
}