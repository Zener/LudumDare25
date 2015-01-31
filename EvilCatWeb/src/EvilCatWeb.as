package
{
	import flash.display.Sprite;
	
	[SWF(width=640, height=480, backgroundColor='0x2A98FE', frameRate='50', allowScriptAccess='always', allowfullscreen='true')]
	public class EvilCatWeb extends Sprite
	{
		public function EvilCatWeb()
		{
			this.addChild(new EvilCatAIR());
		}
	}
}