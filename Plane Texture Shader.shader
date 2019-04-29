Shader "CMPM131HW1/Plane Texture Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		//First of 2 passes
        LOD 100
		Pass
		{
		Tags { "LightMode" = "ForwardBase"}
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
			uniform float4 _LightColor0;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;

				const float PI = 3.14159;

				//make the plane float along the y axis
				float rad = fmod(_Time.y, PI *2.0);
				float newx = v.vertex.x;
				float newy = v.vertex.y + 0.25 * sin(rad);
				float newz = v.vertex.z;

				float4 xyz = float4(newx, newy, newz, 1.0);
				o.vertex = UnityObjectToClipPos(xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = float4(_LightColor0.rgb, 1.0) + tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
		//second pass for multiple point lights
        Pass
        {
		Tags { "LightMode" = "ForwardAdd"}
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
			uniform float4 _LightColor0;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				
				const float PI = 3.14159;
				
				float rad = fmod(_Time.y, PI *2.0);
				float newx = v.vertex.x;
				float newy = v.vertex.y + 0.25 * sin(rad); // make the plane float
				float newz = v.vertex.z;

				float4 xyz = float4(newx, newy, newz, 1.0);
                o.vertex = UnityObjectToClipPos(xyz);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = float4(_LightColor0.rgb, 1.0) + tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
