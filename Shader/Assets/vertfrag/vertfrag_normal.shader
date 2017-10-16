Shader "vertfrag/normal" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_NormalMap("NormalMap",2D) = "Bump"{}  
	}
	SubShader {
		Tags { "RenderType"="Opacue" "LightMode"="ForwardBase" }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _MainTex;
			sampler2D _NormalMap;
			float4 _LightColor0;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos:SV_POSITION;
				float3 lightDir : TEXCOORD1;
			};

			v2f vert(appdata_tan v)  
            {  
                v2f o;  
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);  
                o.uv = v.texcoord.xy;  
                TANGENT_SPACE_ROTATION;  
                o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));  
                return o;  
            }  

			float4 frag(v2f IN) : SV_TARGET
			{
				float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv));
				float4 col = tex2D(_MainTex, IN.uv);
				float3 ambient = col.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				float3 diffuse = col * _LightColor0.rgb * max(0, dot(normal, IN.lightDir)) * _Color.rgb;
				return float4(ambient + diffuse, 1);
			}

			ENDCG
		}
	}
}
