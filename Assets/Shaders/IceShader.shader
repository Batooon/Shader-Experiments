Shader "Custom/IceShader"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1,1,1,1)
        _CrackDepth("Crack Depth", Range(0, 1)) = 0.5
        _NoiseScale("Noise Scale", Range(0, 1)) = 0.5
        _NoiseFreq("Noise Frequency", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _BaseColor;
        float _CrackDepth;
        float _NoiseScale; // scale of the noise
        float _NoiseFreq; // frequency of the noise
        float4 _ViewAngle;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        // Noise function for generating cracks
        float noise(float3 pos)
        {
            return frac(sin(dot(pos, float3(12.9898, 78.233, 151.7182))) * 43758.5453);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Sample the texture at the interpolated UV coordinates
            fixed4 c = _BaseColor;
            o.Albedo = c.rgb;

            // Calculate the depth of the cracks using the noise function
            float3 noisePos = float3(IN.uv_MainTex * _NoiseScale, 0) * _NoiseFreq;
            float crackDepth = _CrackDepth * noise(noisePos);
            o.Normal = float3(0, 0, crackDepth);

            // Set the specular and smoothness values
            o.Metallic = 0;
            o.Smoothness = 0.5;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}