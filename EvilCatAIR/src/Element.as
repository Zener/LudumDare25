package
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Element extends Sprite
	{
		public static var m_physScale:Number = 20;
		public static var GFX_SCALE:Number = 50;
		
		public static var GFX_X:Number = 0;
		public static var GFX_Y:Number = 0;
		
		public var mBody:b2Body;
		public var mBoxWidth:Number;
		public var mBoxHeight:Number;
		public var mIsOnground:Boolean = true;
		public var mBrokenThreshold:Number = 0;
		public var mTimeToLife:Number = 0;
		public var mDestroyMe:Boolean = false;
		public var mFallenDown:Boolean = false;
		protected var mEnergy:Number = 0;
		protected var mGfxScaleY:Number = 1;
		protected var mWorld:b2World;
		protected var mGfxScaleX:Number = 1;
		private var mGfxBitmap:Bitmap = null;
		
		[Embed(source="data/boxtest.png")]
		private static const gfxCat:Class;
		
		[Embed(source="data/platform.png")]
		private static const gfxPlat:Class;
		
		
		
		public function Element(_gfxBitmap:Bitmap = null) 
		{
			mGfxBitmap = _gfxBitmap;			
		}
		
		public function init(m_world:b2World, _x:Number, _y:Number, _width:Number, _height:Number, _static:Boolean = false):void
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
			fd.friction = 0.2;
			fd.restitution = 0.1;
			fd.shape = sd;			
			
			mBoxWidth =(_width) / m_physScale;
			mBoxHeight =(_height) / m_physScale;
			sd.SetAsBox(mBoxWidth, mBoxHeight);
			bd.position.Set(_x / m_physScale, _y / m_physScale);
			mBody = m_world.CreateBody(bd);
			mBody.CreateFixture(fd);		
			
			
		}
		
		
		public function loadGfx():void
		{
			var back:Bitmap;
			if (mGfxBitmap)
			{
				back = mGfxBitmap;
			}
			else
			{
				if (mBody.GetType() == b2Body.b2_staticBody)
				{
					back = new gfxPlat as Bitmap;
				}
				else
				{
					back = new gfxCat as Bitmap;
				}
			}
			
			
			back.x = -back.width/2;
			back.y = -back.height/2;
			addChild(back);
			
			mGfxScaleX = mBoxWidth*GFX_SCALE*2 / back.width;
			mGfxScaleY = mBoxHeight*GFX_SCALE*2 / back.height;
		}
		
		
		public function logicUpdate():void
		{
			//if (b == null) return;
			
			var i:int = 0;
			
			
			
			var contactList:b2ContactEdge = mBody.GetContactList();
			
			mIsOnground = false;
			while (contactList)				
			{
				var contact:b2Contact = contactList.contact;
				var b1:b2Fixture =  contact.GetFixtureA();
				var b2:b2Fixture =  contact.GetFixtureB();
				mIsOnground = true;
				contactList = contactList.next;
			}
			
			//broken?
			mFallenDown = false;
			if (mBrokenThreshold > 0)
			{
				if (mIsOnground)
				{
					Cat.smEvilness += mEnergy;
					mBrokenThreshold -= mEnergy*Cat.smDestructivePower;
					//trace("brokenThreshold" + brokenThreshold);
					//if (energy > 0) trace("energy " + energy);
					if (mBrokenThreshold < 0)
					{
						//trace("Se ha roto");
						Cat.smEvilness += 10000;
						Cat.smDestroyedCount++;
						mDestroyMe = true;
					}
					else if (mEnergy > 0)
					{
						//trace("Se ha caido");
						mFallenDown = true;
					}
					mEnergy = 0;
				}
				else
				{
					
				}
				mEnergy = mBody.GetLinearVelocity().LengthSquared() + mBody.GetAngularVelocity();	
			}
			
			
			//Render
			x = ((mBody.GetWorldCenter().x)*GFX_SCALE);
			y = ((mBody.GetWorldCenter().y)*GFX_SCALE);
			scaleX = mGfxScaleX;
			scaleY = mGfxScaleY;
			
			rotation = mBody.GetAngle()*180.0/Math.PI;
			
		}
		
		
		
		public function setMass(n:Number):void
		{
			var mass:b2MassData = new b2MassData;
			mBody.GetMassData(mass);
			mass.mass = n;
			mBody.SetMassData(mass);
		}
		
		
		public function getMass():Number
		{
			var mass:b2MassData = new b2MassData;
			return mass.mass;			
		}
	}
}