Shader "CMPM131HW1/Mosquito Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NumCells ("Number of Cells", Float) = 1.0
		_Intensity ("Intensity", range(1.0, 10)) = 1.0
    }
    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
			uniform float _Size;
            uniform float4 _MainTex_TexelSize; //special value
			uniform float _NumCells;
            uniform int _Intensity;
			uniform int _MouseButtonPressed;
			uniform float _mX;
            uniform float _mY;

			sampler2D _MainTex;
			float4 _MainTex_ST;

            struct vIn
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vOut
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
			//usual vertex shader except TRANSFORM_TEX will transform the Texture coordinates into uv
            vOut vert (vIn v)
            {
                vOut o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            
            fixed4 frag (vOut i) : SV_Target
            {
				//A size of a texel is 1/texWidth X 1/texHeight
				float2 texel = float2(
					_MainTex_TexelSize.x * (_mY/_ScreenParams.x), 
					_MainTex_TexelSize.y * (_mY/_ScreenParams.y)
				   );

				//Sharpener matrix
				float3x3 GSharp = float3x3(0,-1,0,-1,5,-1,0,-1,0);
				// fetch the 3x3 neighborhood of a fragment

				float tx0y0 = tex2D( _MainTex, i.uv + texel * float2( -1, -1 ) ).r;
				float tx0y1 = tex2D( _MainTex, i.uv + texel * float2( -1,  0 ) ).r;
				float tx0y2 = tex2D( _MainTex, i.uv + texel * float2( -1,  1 ) ).r;

				float tx1y0 = tex2D( _MainTex, i.uv + texel * float2(  0, -1 ) ).r;
				float tx1y1 = tex2D( _MainTex, i.uv + texel * float2(  0,  0 ) ).r;
				float tx1y2 = tex2D( _MainTex, i.uv + texel * float2(  0,  1 ) ).r;

				float tx2y0 = tex2D( _MainTex, i.uv + texel * float2(  1, -1 ) ).r;
				float tx2y1 = tex2D( _MainTex, i.uv + texel * float2(  1,  0 ) ).r;
				float tx2y2 = tex2D( _MainTex, i.uv + texel * float2(  1,  1 ) ).r;

				//New value of texel that is sharpened
				float valueGSharp = GSharp[0][0] * tx0y0 + GSharp[1][0] * tx1y0 + GSharp[2][0] * tx2y0 + 
						GSharp[0][1] * tx0y1 + GSharp[1][1] * tx1y1 + GSharp[2][1] * tx2y1 + 
						GSharp[0][2] * tx0y2 + GSharp[1][2] * tx1y2 + GSharp[2][2] * tx2y2;

				float G = valueGSharp;
        
				float4 edgePix = float4(float3(1.0,1.0,1.0) - float3(G, G, G), 1.0);
				//Grab original pixel
				float4 texPix = tex2D(_MainTex, i.uv);
				
				//lerp = linear interpolation
				//returning color based on a weighted estimate between texPix and 
				//edgePix. The weight is based on mouse position.
				float4 edgeCol = lerp(texPix, edgePix, -_mX/_ScreenParams.x);

				//Change Intensity by Mouse buttons
				//Left Click: Increase Intensity
				//Right Click: Decrease Intensity
				if (_MouseButtonPressed != 0)
					_Intensity = _MouseButtonPressed;
				if (_Intensity < 1)
					_Intensity = 1;

				
				return edgeCol * (_Intensity);
               
            }
            ENDCG
        }
    }
}
