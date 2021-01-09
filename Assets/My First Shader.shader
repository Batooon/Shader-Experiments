// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Shader"
{
	Properties
	{
		_Tint("Tint",Color) = (1,1,1,1)
		_MainTex("Main Texture",2D)="white"{}
	}

		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			struct Interpolators {
				float4 position:SV_POSITION;
				float2 uv:TEXCOORD0;
			};

			struct VertexData {
				float4 position:POSITION;
				float2 uv:TEXCOORD0;
			};

			//Has to return final coordinates of a vertex
			//To draw a sphere our vertex program has to produce a correct vertex position.
			//So we need to know the object-space position of the vertex. 
			//We access it by adding a variable with the POSITION semantic
			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;

				i.position = UnityObjectToClipPos(v.position);
				//i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;
			}

				//Supposed to output an RGBA color value for one pixel
				//We're working with an opaque shader, so our shader just ignores the alpha channel
			float4 MyFragmentProgram(Interpolators i) :SV_TARGET //the output of the vertex program is used as input for the fragment program. That's why we're passing float4 position
			{
				//return float4(i.uv + 0.5,1,1) * _Tint;
				return tex2D(_MainTex,i.uv) * _Tint;
			}
			ENDCG
		}
	}
}