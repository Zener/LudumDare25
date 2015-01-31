package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;
	
	public class EleBall extends Element
	{
		public function EleBall(_gfxBitmap:Bitmap=null)
		{
			super(_gfxBitmap);
		}
		
		
		override public function init(m_world:b2World, _x:Number, _y:Number, _width:Number, _height:Number, _static:Boolean = false):void
		{
			mWorld = m_world;
			// Add bodies
			var cd1:b2CircleShape = new b2CircleShape();
			cd1.SetRadius(_width/m_physScale);
			cd1.SetLocalPosition(new b2Vec2( -_width / m_physScale, _width / m_physScale));
				
			var fd:b2FixtureDef = new b2FixtureDef();
			//var sd:b2PolygonShape = new b2PolygonShape();
			var bd:b2BodyDef = new b2BodyDef();
			if (_static)
			{
				bd.type = b2Body.b2_staticBody;	
			}
			else
			{
				bd.type = b2Body.b2_dynamicBody;
			}
			
			fd.density = 0.6;
			fd.friction = 0.1;
			fd.restitution = 0.7;
			fd.shape = cd1;			
			
			mBoxWidth =(_width) / m_physScale;
			mBoxHeight =(_height) / m_physScale;
			//sd.SetAsBox(boxWidth, boxHeight);
			bd.position.Set(_x / m_physScale, _y / m_physScale);
			mBody = m_world.CreateBody(bd);
			mBody.CreateFixture(fd);		
			
			
		}
	}
}