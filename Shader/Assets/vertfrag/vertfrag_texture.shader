Shader "vertfrag/texture"
{
	Properties
	{
		_MainColor("Main Color(RGB)", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture(RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opacue" }
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			half4 _MainColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}


			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = col * _MainColor;
				return col;
			}

			ENDCG
		}
	}
}