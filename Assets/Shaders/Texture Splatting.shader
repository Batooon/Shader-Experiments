// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Texture Splatting"
{
	Properties
	{
		_MainTex("Splat Map", 2D) = "white" {}
		[NoScaleOffset] _Texture1("Texture 1",2D)="white"{}
		[NoScaleOffset] _Texture2("Texture 2",2D)="white"{}
		[NoScaleOffset] _Texture3("Texture 3",2D)="white"{}
		[NoScaleOffset] _Texture4("Texture 4",2D)="white"{}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _Texture1, _Texture2, _Texture3, _Texture4;
			
			struct Interpolators {
				float4 position:SV_POSITION;
				float2 uv:TEXCOORD0;
				float2 uvSplat:TEXCOORD1;
			};

			struct VertexData {
				float4 position:POSITION;
				float2 uv:TEXCOORD0;
			};

			//Has to return final coordinates of a vertex
			//To draw a sphere(or any other object) our vertex program has to produce a correct vertex position.
			//So we need to know the object-space position of the vertex. 
			//We access it by adding a variable with the POSITION semantic
			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;

				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvSplat = v.uv;
				return i;
			}

			//Supposed to output an RGBA color value for one pixel
			//We're working with an opaque shader, so our shader just ignores the alpha channel
			float4 MyFragmentProgram(Interpolators i) :SV_TARGET //the output of the vertex program is used as input for the fragment program. That's why we're passing float4 position
			{
				float4 splat=tex2D(_MainTex,i.uvSplat);
				return tex2D(_Texture1, i.uv)*splat.r+
					tex2D(_Texture2,i.uv)*splat.g+
						tex2D(_Texture3,i.uv)*splat.b+
							tex2D(_Texture4,i.uv)*(1-splat.r-splat.g-splat.b);
			}
			ENDCG
		}
	}
}