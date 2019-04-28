Shader "Custom/RenderToTexture_CA"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {} 
		_Color1("Live Color", Color) = (1,1,1,1)
		_Color2("Dead Color", Color) = (1,1,1,1)
		_Color3("Transition Color", Color) = (1,1,1,1)
    }
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize;
			uniform float4 _Color1;
			uniform float4 _Color2;
			uniform float4 _Color3;
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
			
			//an ordinary vertex shader, converting the object coordinates to clip
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
           
            sampler2D _MainTex;
            
			//The cellular automata algorithm happens in the fragment shader
			fixed4 frag(v2f i) : SV_Target
			{
				//we get the texture pixel from the width and height of each pixel on the texture
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
                // get the current x and y position of the vertex
                float cx = i.uv.x;
                float cy = i.uv.y;
                
				//we query the texel from the x and y texture coordinates
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
                
				//defining the cardinal directions by adding/subtracting one texel unit from the current uv position
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
                
                float4 arr[8];
                //We query the neighbors of the current cell
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
                arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW

				//counting how many cells are alive
                int cnt = 0;
                for(int i=0;i<8;i++){
                    if (arr[i].r > 0.5) {
                        cnt++;
                    }
                }
                //If you want to represent different colors as different states,
				//Compare each color channel accordingly such that the cell behaves like it should.
				//This also requires altering the "else" statements into else if's
				//Ex. if (C.g >=0.5 || C.b >= 0.5)
                if (C.r >= 0.5) { //cell is alive
                    if (cnt == 2 || cnt == 3) {
                        //Any live cell with two or three live neighbours lives on to the next generation.
                
                        return _Color1; //float4(1.0,1.0,1.0,1.0)
                    } else {
                        //Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
                        //Any live cell with more than three live neighbours dies, as if by overpopulation.

                        return _Color2; //float4(0.0,0.0,0.0,1.0);
                    }
                } else { //cell is dead
                    if (cnt == 2) {//Chris: Changing the count to 2 makes the texture behave in a noiselike fashion
                        //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

                        return _Color3; //float4(1.0,1.0,1.0,1.0);
                    } else {
                        return _Color2; //float4(0.0,0.0,0.0,1.0);

                    }
                }
                
            }

			ENDCG
		}

	}
	FallBack "Diffuse"
}