package
{
	import flash.display.Bitmap;

	public class EleVase extends Element
	{
		[Embed(source="data/vase.png")]
		private static const gfxVase:Class;
		
		
		public function EleVase()
		{
			super();
			mBrokenThreshold = 350;
		}
		
		override public function loadGfx():void
		{
			var back:Bitmap = new gfxVase as Bitmap;
			back.x = -back.width/2;
			back.y = -back.height/2;
			addChild(back);
			
			mGfxScaleX = mBoxWidth*GFX_SCALE*2 / back.width;
			mGfxScaleY = mBoxHeight*GFX_SCALE*2 / back.height;
		}
		
		
		
		
		
	}
}