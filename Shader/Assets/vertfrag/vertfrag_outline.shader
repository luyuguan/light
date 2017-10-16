Shader "vertfrag/outline" {
	Properties {
		_MainColor ("Color(RGB)", Color) = (1,1,1,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_BumpTex("Bump Texture", 2D) = "bump" {}
		_BlockColor("Block Color", Color) = (1, 1, 1, 1)
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower("Rim Power", Range(0.001, 5)) = 1
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineFactor("Outline Factor", Range(0.001, 0.1)) = 0.1
	}
	SubShader {
		
		Pass
        {
            Cull Front //剔除前面
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct v2f
            {
                float4 vertex :POSITION;
            };
 
            float _OutlineFactor;
            half4 _OutLineColor;
 
            v2f vert(appdata_full v)
            {
                v2f o;
                float4 view_vertex = mul(UNITY_MATRIX_MV,v.vertex);
                float3 view_normal = mul(UNITY_MATRIX_IT_MV,v.normal);
                view_vertex.xyz += normalize(view_normal) * _OutlineFactor; 
                o.vertex = mul(UNITY_MATRIX_P,view_vertex);
                return o;
            }
 
            half4 frag(v2f IN):COLOR
            {
                return _OutLineColor;
            }
            ENDCG
        }

		Pass
		{
			Tags { "LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _MainColor;
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
				float3 ambient = _MainColor.rgb * tex * UNITY_LIGHTMODEL_AMBIENT.rgb;
				float3 diffuse = max(0, dot(normal, IN.lightDir)) * _LightColor0.rgb * _MainColor.rgb * tex;
				float3 rim = (1 - max(0, dot(normal, IN.viewDir)));
				if(_RimPower <= 0.005)
				{
					return float4(ambient + diffuse, 1);
				}
				else
				{
					rim = pow(rim, 1/_RimPower) * _RimColor.rgb;
					return float4(ambient + diffuse + rim, 1);
				}
			}
			ENDCG
		}
	}
}
