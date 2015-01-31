package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Bitmap;

	public class EleWashingMachine extends Element
	{
		public function EleWashingMachine(_gfxBitmap:Bitmap = null)
		{
			super(_gfxBitmap);
		}
		
		
		override public function logicUpdate():void
		{
			super.logicUpdate();
			
			var impulse:b2Vec2 = new b2Vec2((Math.random() - Math.random())*0.7, 0);
			var point:b2Vec2 = new b2Vec2(0 , 0);	
			
			//body.ApplyForce(impulse, point);
			mBody.ApplyImpulse(impulse, point);
		}
	}
}