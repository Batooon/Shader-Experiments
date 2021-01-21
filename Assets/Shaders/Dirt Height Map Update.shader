Shader "Dirt Height Map Update"
{
    Properties
    {
        _DrawPosition("Draw Position", Vector) = (-1,-1,0,0)
        _BrushRadius("Brush Radius",Range(0.01,0.5))=0.15
        _BrushHardness("Brush Hardness",Range(0.01,0.5))=0.05
    }

    SubShader
    {
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            float4 _DrawPosition;
            float _BrushRadius;
            float _BrushHardness;

            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                float4 previousColor = tex2D(_SelfTexture2D, IN.localTexcoord.xy);
                float4 drawColor = smoothstep(_BrushHardness, _BrushRadius, distance(IN.localTexcoord.xy, _DrawPosition));

                return min(previousColor, drawColor);
            }
            ENDCG
        }
    }
}