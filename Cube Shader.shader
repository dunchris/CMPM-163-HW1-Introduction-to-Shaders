Shader "CMPM131HW1/Cube Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Float) = 10 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
    }
    SubShader
    {
        //write a pass for multiple point lights so that the object 
		//doesn't  become invisible when not lit by a point light
		//First pass must have tag { "LightMode" = "ForwardBase" }
		//Second pass must have tag { "LightMode" = "ForwardAdd" }
        Pass
        {
			Tags { "LightMode" = "ForwardBase" }
			//Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vIn
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                //float2 uv : TEXCOORD0;
            };

            struct vOut
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                //float2 uv : TEXCOORD0;
                float3 WorldCoords : TEXCOORD1;
            };
            uniform float4 _LightColor0; //from UnityCG
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;  
            //sampler2D _MainTex;
            //float4 _MainTex_ST;

			//Constructing a matrix to rotate the cube about the y axis
			float3x3 getRotationMatrixY(float theta) {
				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
			}


            vOut vert (vIn v)
            {
                vOut o;
				const float PI = 3.14159;
				float rad = fmod(_Time.y, PI *2.0);

				float3 rotatedVertex = mul(getRotationMatrixY(rad), v.vertex.xyz);
				float4 xyz = float4(rotatedVertex, 1.0);

                o.WorldCoords = mul(unity_ObjectToWorld, v.vertex);
                
                o.vertex = UnityObjectToClipPos(xyz); //Send new vertices to clip pos
				o.normal = UnityObjectToWorldNormal(v.normal);


                return o;
            }

            fixed4 frag (vOut i) : SV_Target
            {
              
                float3 P = i.WorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);

                float3 Kd = _Color.rgb;
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 Ks = _SpecColor.rgb;
                float3 Kl = _LightColor0.rgb;

                float3 ambient = Ka;

                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;


                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                float3 specular = Ks * Kl * specularVal;

                if (diffuseVal <= 0){
                    specularVal = 0;
                }
				
				//return _Color;
                return float4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
        }

		Pass
		{
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vIn
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				//float2 uv : TEXCOORD0;
			};

			struct vOut
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				//float2 uv : TEXCOORD0;
				float3 WorldCoords : TEXCOORD1;
			};
			uniform float4 _LightColor0; //from UnityCG
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			//sampler2D _MainTex;
			//float4 _MainTex_ST;

			float3x3 getRotationMatrixY(float theta) {
				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
			}


			vOut vert(vIn v)
			{
				vOut o;
				const float PI = 3.14159;
				float rad = fmod(_Time.y, PI *2.0);

				float3 rotatedVertex = mul(getRotationMatrixY(rad), v.vertex.xyz);
				float4 xyz = float4(rotatedVertex, 1.0);

				o.WorldCoords = mul(unity_ObjectToWorld, v.vertex);
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(xyz);
				o.normal = UnityObjectToWorldNormal(v.normal);


				return o;
			}

			fixed4 frag(vOut i) : SV_Target
			{

				float3 P = i.WorldCoords.xyz;
				float3 N = normalize(i.normal);
				float3 V = normalize(_WorldSpaceCameraPos - P);
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
				float3 H = normalize(L + V);

				float3 Kd = _Color.rgb;
				float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
				float3 Ks = _SpecColor.rgb;
				float3 Kl = _LightColor0.rgb;

				float3 ambient = Ka;

				float diffuseVal = max(dot(N, L), 0);
				float3 diffuse = Kd * Kl * diffuseVal;


				float specularVal = pow(max(dot(N,H), 0), _Shininess);
				float3 specular = Ks * Kl * specularVal;

				if (diffuseVal <= 0) {
					specularVal = 0;
				}

				//return _Color;
				return float4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
    }
    
}
