Shader "vertfrag/blocktrans" {
	Properties {
		_Color ("Color(RGB)", Color) = (1,1,1,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_BumpTex("Bump Texture", 2D) = "bump" {}
		_BlockColor("Block Color", Color) = (1, 1, 1, 1)
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower("Rim Power", Range(0.001, 5)) = 1
	}
	SubShader {
		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			ZTest Greater
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _BlockColor;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f ret;
				ret.pos = UnityObjectToClipPos(v.vertex);
				return ret;
			}

			fixed4 frag(v2f IN) : SV_TARGET
			{
				return _BlockColor;
			}
			ENDCG
		}
		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _Color;
			float4 _RimColor;
			sampler2D _MainTex;
			sampler2D _BumpTex;
			float4 _LightColor0;
			half _RimPower;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD;
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			v2f vert(appdata_tan v)
			{
				v2f ret;
				ret.pos = UnityObjectToClipPos(v.vertex);
				ret.uv = v.texcoord.xy;
				TANGENT_SPACE_ROTATION;
				ret.lightDir = normalize(mul(rotation, ObjSpaceLightDir(v.vertex)));
				ret.viewDir = normalize(mul(rotation, ObjSpaceViewDir(v.vertex)));
				return ret;
			}

			float4 frag(v2f IN) : SV_TARGET
			{
				float3 tex = tex2D(_MainTex, IN.uv).rgb;
				float3 normal = UnpackNormal(tex2D(_BumpTex, IN.uv));
				float3 ambient = _Color.rgb * tex * UNITY_LIGHTMODEL_AMBIENT.rgb;
				float3 diffuse = max(0, dot(normal, IN.lightDir)) * _LightColor0.rgb * _Color.rgb * tex;
				if(_RimPower <= 0.005)
				{
					return float4(ambient + diffuse, 1);
				}
				float3 rim = (1 - max(0, dot(normal, IN.viewDir)));
				rim = pow(rim, 1/_RimPower) * _RimColor.rgb;
				return float4(ambient + diffuse + rim, 1);
			}

			ENDCG
		}
	}
}
