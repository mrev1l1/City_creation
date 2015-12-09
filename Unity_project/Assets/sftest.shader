// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:0,culm:0,dpts:2,wrdp:True,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:31377,y:32484|diff-18-OUT,spec-24-OUT,normal-22-OUT;n:type:ShaderForge.SFN_VertexColor,id:2,x:32344,y:32849;n:type:ShaderForge.SFN_Tex2d,id:3,x:32515,y:32466,ptlb:TextureA,ptin:_TextureA,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-16-OUT;n:type:ShaderForge.SFN_Tex2d,id:4,x:32515,y:32665,ptlb:TexureB,ptin:_TexureB,tex:c4e410fc0ef07244596535df6ca8cc1a,ntxv:0,isnm:False|UVIN-16-OUT;n:type:ShaderForge.SFN_TexCoord,id:15,x:33140,y:32782,uv:0;n:type:ShaderForge.SFN_Multiply,id:16,x:33016,y:32906|A-15-UVOUT,B-17-OUT;n:type:ShaderForge.SFN_Vector1,id:17,x:33140,y:33051,v1:5;n:type:ShaderForge.SFN_Lerp,id:18,x:32049,y:32531|A-3-RGB,B-4-RGB,T-2-R;n:type:ShaderForge.SFN_Tex2d,id:19,x:32623,y:32918,ptlb:NoramlA,ptin:_NoramlA,tex:bbab0a6f7bae9cf42bf057d8ee2755f6,ntxv:3,isnm:True|UVIN-16-OUT;n:type:ShaderForge.SFN_Tex2d,id:20,x:32623,y:33132,ptlb:NormalB,ptin:_NormalB,tex:85e489cb9f3db0445946ba18e512c012,ntxv:0,isnm:False|UVIN-16-OUT;n:type:ShaderForge.SFN_Lerp,id:21,x:32046,y:33044|A-19-RGB,B-20-RGB,T-2-R;n:type:ShaderForge.SFN_Normalize,id:22,x:31965,y:32711|IN-21-OUT;n:type:ShaderForge.SFN_ConstantLerp,id:24,x:31807,y:32564,a:0.4,b:1|IN-2-R;proporder:3-4-19-20;pass:END;sub:END;*/

Shader "Custom/sftest" {
    Properties {
        _TextureA ("TextureA", 2D) = "white" {}
        _TexureB ("TexureB", 2D) = "white" {}
        _NoramlA ("NoramlA", 2D) = "bump" {}
        _NormalB ("NormalB", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _TextureA; uniform float4 _TextureA_ST;
            uniform sampler2D _TexureB; uniform float4 _TexureB_ST;
            uniform sampler2D _NoramlA; uniform float4 _NoramlA_ST;
            uniform sampler2D _NormalB; uniform float4 _NormalB_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float2 node_16 = (i.uv0.rg*5.0);
                float4 node_2 = i.vertexColor;
                float3 normalLocal = normalize(lerp(UnpackNormal(tex2D(_NoramlA,TRANSFORM_TEX(node_16, _NoramlA))).rgb,tex2D(_NormalB,TRANSFORM_TEX(node_16, _NormalB)).rgb,node_2.r));
                float3 normalDirection =  normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
///////// Gloss:
                float gloss = 0.5;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float node_24 = lerp(0.4,1,node_2.r);
                float3 specularColor = float3(node_24,node_24,node_24);
                float3 specular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * lerp(tex2D(_TextureA,TRANSFORM_TEX(node_16, _TextureA)).rgb,tex2D(_TexureB,TRANSFORM_TEX(node_16, _TexureB)).rgb,node_2.r);
                finalColor += specular;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _TextureA; uniform float4 _TextureA_ST;
            uniform sampler2D _TexureB; uniform float4 _TexureB_ST;
            uniform sampler2D _NoramlA; uniform float4 _NoramlA_ST;
            uniform sampler2D _NormalB; uniform float4 _NormalB_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float2 node_16 = (i.uv0.rg*5.0);
                float4 node_2 = i.vertexColor;
                float3 normalLocal = normalize(lerp(UnpackNormal(tex2D(_NoramlA,TRANSFORM_TEX(node_16, _NoramlA))).rgb,tex2D(_NormalB,TRANSFORM_TEX(node_16, _NormalB)).rgb,node_2.r));
                float3 normalDirection =  normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
///////// Gloss:
                float gloss = 0.5;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float node_24 = lerp(0.4,1,node_2.r);
                float3 specularColor = float3(node_24,node_24,node_24);
                float3 specular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * lerp(tex2D(_TextureA,TRANSFORM_TEX(node_16, _TextureA)).rgb,tex2D(_TexureB,TRANSFORM_TEX(node_16, _TexureB)).rgb,node_2.r);
                finalColor += specular;
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
