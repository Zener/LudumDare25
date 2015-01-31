package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class EleParticle extends Element
	{
		public function EleParticle()
		{
			super();
		}
		
		public function loadGfxFromSprite(src:Sprite):void
		{
			var a:BitmapData = new BitmapData(src.width, src.height, true, 0);
			//src.x = - Math.random()*10;
			//src.y = - Math.random()*10;
			var m:Matrix = new Matrix();
			m.scale(5,5);
			m.translate((Math.random())*src.width, (Math.random())*src.height); 
			a.draw(src,m);
		
			
			var back:Bitmap = new Bitmap(a);
			back.x = -back.width/2;
			back.y = -back.height/2;
			addChild(back);
			
			mGfxScaleX = mBoxWidth*GFX_SCALE*2 / back.width;
			mGfxScaleY = mBoxHeight*GFX_SCALE*2 / back.height;
			
			//trace("particle x" + body.GetWorldCenter().x);
			//trace("particle y" + body.GetWorldCenter().y);
		}
		
		
		override public function logicUpdate():void
		{
			super.logicUpdate();
			
			mTimeToLife--;
			if (mTimeToLife < 0) alpha -= 0.05;
			if (alpha <= 0) mDestroyMe = true;
		}
	}
}