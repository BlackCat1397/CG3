// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/KubeShaderLeaves"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _ClearColor ("Clear color", Color) = (0.5, 0.5, 0.5, 1)
        _FogStart ("Fog start", Float) = 20
        _FogEnd ("Fog end", Float) = 100
        _Density ("Fog density", Float) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
//            #pragma multi_compile_fog
            //#pragma surface **alpha:blend**
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
//                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                half3 wN : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;

            float _FogStart;
            float _FogEnd;
            float4 _ClearColor;
            float _Density;

            
            v2f vert (appdata v, float3 normal : NORMAL)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
//                UNITY_TRANSFER_FOG(o,o.vertex);

//                o.uv = v.uv;
                o.wN = UnityObjectToWorldNormal(normal);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float cameraDist = length(i.posWorld.xyz - _WorldSpaceCameraPos.xyz);
                fixed4 c = 0;
                float f = (_FogEnd - cameraDist)/(_FogEnd - _FogStart);
                f = pow(2.7182818285, -1*pow(-cameraDist*_Density, 2));
                f = f>=0?(f<=1?f:1):0;
                c.rgb = (1-f)*_ClearColor + f*_Color;
                return c;
            }
            ENDCG
        }
    }
Dependency "OptimizedShader" = "Hidden/Nature/Tree Creator Bark Optimized"
FallBack "Diffuse"
}
