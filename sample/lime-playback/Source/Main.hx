package;


import lime.app.Application;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.utils.Assets;
import lime.utils.Float32Array;

#if flash
import flash.display.Bitmap;
#end


class Main extends Application {
	
	
	private var cairoSurface:CairoImageSurface;
	private var glBuffer:GLBuffer;
	private var glMatrixUniform:GLUniformLocation;
	private var glProgram:GLProgram;
	private var glTexture:GLTexture;
	private var glTextureAttribute:Int;
	private var glVertexAttribute:Int;
	private var image:Image;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		switch (context.type) {
			
			case CAIRO:
				
				var cairo = context.cairo;
				
				if (image == null && preloader.complete) {
					
					image = Assets.getImage ("assets/lime.png");
					image.format = BGRA32;
					image.premultiplied = true;
					
					cairoSurface = CairoImageSurface.fromImage (image);
					
				}
				
				var r = ((context.attributes.background >> 16) & 0xFF) / 0xFF;
				var g = ((context.attributes.background >> 8) & 0xFF) / 0xFF;
				var b = (context.attributes.background & 0xFF) / 0xFF;
				var a = ((context.attributes.background >> 24) & 0xFF) / 0xFF;
				
				cairo.setSourceRGB (r, g, b);
				cairo.paint ();
				
				if (image != null) {
					
					image.format = BGRA32;
					image.premultiplied = true;
					
					cairo.setSourceSurface (cairoSurface, 0, 0);
					cairo.paint ();
					
				}
			
			case CANVAS:
				
				var ctx = context.canvas2D;
				
				if (image == null && preloader.complete) {
					
					image = Assets.getImage ("assets/lime.png");
					
					ctx.fillStyle = "#" + StringTools.hex (context.attributes.background, 6);
					ctx.fillRect (0, 0, window.width, window.height);
					ctx.drawImage (image.src, 0, 0, image.width, image.height);
					
				}
			
			case DOM:
				
				var element = context.dom;
				
				if (image == null && preloader.complete) {
					
					image = Assets.getImage ("assets/lime.png");
					
					element.style.backgroundColor = "#" + StringTools.hex (context.attributes.background, 6);
					element.appendChild (image.src);
					
				}
			
			case FLASH:
				
				var sprite = context.flash;
				
				if (image == null && preloader.complete) {
					
					image = Assets.getImage ("assets/lime.png");
					
					#if flash
					var bitmap = new Bitmap (image.src);
					sprite.addChild (bitmap);
					#end
					
				}
			
			case OPENGL, OPENGLES, WEBGL:
				
				var gl = context.webgl;
				
				if (image == null && preloader.complete) {
					
					image = Assets.getImage ("assets/lime.png");
					
					var vertexSource = 
						
						"attribute vec4 aPosition;
						attribute vec2 aTexCoord;
						varying vec2 vTexCoord;
						
						uniform mat4 uMatrix;
						
						void main(void) {
							
							vTexCoord = aTexCoord;
							gl_Position = uMatrix * aPosition;
							
						}";
					
					var fragmentSource = 
						
						#if !desktop
						"precision mediump float;" +
						#end
						"varying vec2 vTexCoord;
						uniform sampler2D uImage0;
						
						void main(void)
						{
							gl_FragColor = texture2D (uImage0, vTexCoord);
						}";
					
					glProgram = GLProgram.fromSources (gl, vertexSource, fragmentSource);
					gl.useProgram (glProgram);
					
					glVertexAttribute = gl.getAttribLocation (glProgram, "aPosition");
					glTextureAttribute = gl.getAttribLocation (glProgram, "aTexCoord");
					glMatrixUniform = gl.getUniformLocation (glProgram, "uMatrix");
					var imageUniform = gl.getUniformLocation (glProgram, "uImage0");
					
					gl.enableVertexAttribArray (glVertexAttribute);
					gl.enableVertexAttribArray (glTextureAttribute);
					gl.uniform1i (imageUniform, 0);
					
					gl.blendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
					gl.enable (gl.BLEND);
					
					var data = [
						
						image.width, image.height, 0, 1, 1,
						0, image.height, 0, 0, 1,
						image.width, 0, 0, 1, 0,
						0, 0, 0, 0, 0
						
					];
					
					glBuffer = gl.createBuffer ();
					gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
					gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (data), gl.STATIC_DRAW);
					gl.bindBuffer (gl.ARRAY_BUFFER, null);
					
					glTexture = gl.createTexture ();
					gl.bindTexture (gl.TEXTURE_2D, glTexture);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
					
					#if js
					gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image.src);
					#else
					gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, image.buffer.width, image.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
					#end
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
					gl.bindTexture (gl.TEXTURE_2D, null);
					
				}
				
				gl.viewport (0, 0, window.width, window.height);
				
				var r = ((context.attributes.background >> 16) & 0xFF) / 0xFF;
				var g = ((context.attributes.background >> 8) & 0xFF) / 0xFF;
				var b = (context.attributes.background & 0xFF) / 0xFF;
				var a = ((context.attributes.background >> 24) & 0xFF) / 0xFF;
				
				gl.clearColor (r, g, b, a);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				if (image != null) {
					
					var matrix = new Matrix4 ();
					matrix.createOrtho (0, window.width, window.height, 0, -1000, 1000);
					gl.uniformMatrix4fv (glMatrixUniform, false, matrix);
					
					gl.activeTexture (gl.TEXTURE0);
					gl.bindTexture (gl.TEXTURE_2D, glTexture);
					
					#if desktop
					gl.enable (gl.TEXTURE_2D);
					#end
					
					gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
					gl.vertexAttribPointer (glVertexAttribute, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
					gl.vertexAttribPointer (glTextureAttribute, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
					
					gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
					
				}
			
			default:
			
		}
		
	}
	
	
}