package
{
	import flash.display.Bitmap;

	public class EleBed extends Element
	{
		[Embed(source="data/bed.png")]
		private static const gfx:Class;
		
		
		public function EleBed()
		{
			super();
			mBrokenThreshold = 5000;
		}
		
		override public function loadGfx():void
		{
			var back:Bitmap = new gfx as Bitmap;
			back.x = -back.width/2;
			back.y = -back.height/2;
			addChild(back);
			
			mGfxScaleX = mBoxWidth*GFX_SCALE*2 / back.width;
			mGfxScaleY = mBoxHeight*GFX_SCALE*2 / back.height;
		}
	}
}