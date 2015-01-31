package
{
	import flash.display.Bitmap;

	public class EleTft extends Element
	{
		[Embed(source="data/tft.png")]
		private static const gfxVase:Class;
		
		
		public function EleTft()
		{
			super();
			mBrokenThreshold = 150;
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