package
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;

	public class EleWood extends Element
	{
		[Embed(source="data/wood.png")]
		private static const gfx:Class;
		
		
		public function EleWood()
		{
			super();
			mBrokenThreshold = 700;
		}
		
		override public function init(m_world:b2World, _x:Number, _y:Number, _width:Number, _height:Number, _static:Boolean = false):void
		{
			mWorld = m_world;
			// Add bodies
			var fd:b2FixtureDef = new b2FixtureDef();
			var sd:b2PolygonShape = new b2PolygonShape();
			var bd:b2BodyDef = new b2BodyDef();
			if (_static)
			{
				bd.type = b2Body.b2_staticBody;	
			}
			else
			{
				bd.type = b2Body.b2_dynamicBody;
			}
			
			fd.density = 1.0;
			fd.friction = 0.9;
			fd.restitution = 0.1;
			fd.shape = sd;			
			
			mBoxWidth =(_width) / m_physScale;
			mBoxHeight =(_height) / m_physScale;
			sd.SetAsBox(mBoxWidth, mBoxHeight);
			bd.position.Set(_x / m_physScale, _y / m_physScale);
			mBody = m_world.CreateBody(bd);
			mBody.CreateFixture(fd);		
			
			
		}
		
		
		override public function loadGfx():void
		{
			/*var mass:b2MassData = new b2MassData;
			body.GetMassData(mass);
			mass.mass = 1.5;
			body.SetMassData(mass);
			*/
			
			
			
			var back:Bitmap = new gfx as Bitmap;
			back.x = -back.width/2;
			back.y = -back.height/2;
			addChild(back);
			
			mGfxScaleX = mBoxWidth*GFX_SCALE*2 / back.width;
			mGfxScaleY = mBoxHeight*GFX_SCALE*2 / back.height;
		}
	}
}