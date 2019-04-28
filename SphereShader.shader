Shader "CMPM131HW1/SphereShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Speed ("Speed", Float) = 1.0
        _Stretch ("Stretch", Float) = 1.0
    }
    SubShader
    {
        Pass
        {
			Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vIn
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vOut
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

			uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform float _Speed;
            uniform float _Stretch;
            vOut vert (vIn v)
            {   
                if (_Stretch < 0)
                {   _Stretch = 0;}
                vOut o;
                const float PI = 3.14159;
                float sinRad = sin(_Time.y * _Speed);
                float cosRad = cos(_Time.y * _Speed);
                
                float aRad;
                float bRad;
                
                if (sinRad < 0)
                {   aRad = 0;
                    bRad = sinRad;}
                else
                {   aRad = sinRad;
                    bRad = 0;}
                //stretch y and z vertices
                float newx = v.vertex.x;
                float newy = v.vertex.y + (v.vertex.y * _Stretch * aRad);
                float newz = v.vertex.z + (v.vertex.z * _Stretch * -bRad);

                float4 xyz = float4(newx, newy, newz, 1.0);
                

                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }
           
           

            fixed4 frag (vOut i) : SV_Target
            {
				return float4(_LightColor0.rgb, 1.0);
            }

            ENDCG
        }
        Pass
        {
		Tags{"LightMode" = "ForwardAdd"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vIn
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vOut
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

			uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform float _Speed;
            uniform float _Stretch;
            vOut vert (vIn v)
            {   
                if (_Stretch < 0)
                {   _Stretch = 0;}
                vOut o;
                const float PI = 3.14159;
                float sinRad = sin(_Time.y * _Speed);
                float cosRad = cos(_Time.y * _Speed);
                
                float aRad;
                float bRad;
                
                if (sinRad < 0)
                {   aRad = 0;
                    bRad = sinRad;}
                else
                {   aRad = sinRad;
                    bRad = 0;}
                //stretch y and z vertices
                float newx = v.vertex.x;
                float newy = v.vertex.y + (v.vertex.y * _Stretch * aRad);
                float newz = v.vertex.z + (v.vertex.z * _Stretch * -bRad);

                float4 xyz = float4(newx, newy, newz, 1.0);
                

                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }
            
            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }
           

            fixed4 frag (vOut i) : SV_Target
            {
				return float4(_LightColor0.rgb, 1.0);
            }

            ENDCG
        }
    }
}
