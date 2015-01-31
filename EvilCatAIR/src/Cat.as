package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	public class Cat extends Element
	{
		public static var smDestructivePower:Number = 1;
		public static var smEvilness:Number = 1;
		public static var smDestroyedCount:Number = 0;
		public static var smPrevEvilness:Number = 1;
	
		protected var mFrames:Vector.<Bitmap> = new Vector.<Bitmap>;
		protected var mCurrentFrame:Bitmap;
		protected var mCurrentFrameIndex:int = 0;
		protected var mCurrentFrameCounter:Number = 0;
		
		[Embed(source="data/cat.png")]
		private static const gfxCat:Class;
		
		public function Cat() 
		{
			
			
		}
		
		override public function init(m_world:b2World, x:Number, y:Number, _width:Number, _height:Number, _static:Boolean = false):void
		{
			mWorld = m_world;
			y -= 20;
			/*var cd1:b2CircleShape = new b2CircleShape();
			cd1.SetRadius(10.0/m_physScale);
			cd1.SetLocalPosition(new b2Vec2( -10.0 / m_physScale, 10.0 / m_physScale));*/
			
			// Add bodies
			var fd:b2FixtureDef = new b2FixtureDef();
			var sd:b2PolygonShape = new b2PolygonShape();
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			//bd.isBullet = true;
			
			fd.density = 1.5;
			fd.friction = 0.9;
			fd.restitution = 0.1;
			
			/*fd.density = 1.0;
			fd.friction = 0.1;
			fd.restitution = 0.01;*/	
			
			fd.shape = sd;			
			
			mBoxWidth = _width/m_physScale;
			mBoxHeight = _height/m_physScale;
			
			sd.SetAsBox(mBoxWidth, mBoxHeight);
			//bd.position.Set((640/2+100+Math.random()*0.02 - 0.01) / m_physScale, (360-5-i*25) / m_physScale);
			bd.position.Set(x / m_physScale, y / m_physScale);
			mBody = m_world.CreateBody(bd);
			mBody.CreateFixture(fd);		
			
			
			
			var source:Bitmap = new gfxCat as Bitmap;
			for(var i:int = 0; i < 9; i++)
			{
				var bData:BitmapData = new BitmapData(100, 100);						
				bData.copyPixels(source.bitmapData, new Rectangle(i*100, 0, 100, 100), new Point());
				var b:Bitmap = new Bitmap(bData);
				mFrames[i] = b;
			}
			
			
			
			mCurrentFrameIndex = 1;
			mCurrentFrame = mFrames[mCurrentFrameIndex];
			
			
			var back:Bitmap = mCurrentFrame;
			back.name = "Frame";
			
			
			
			
			
			back.x = -100/2;
			back.y = -100/2;
			
			addChild(back);
			mGfxScaleX = mBoxWidth*GFX_SCALE*4 / 100;
			mGfxScaleY = mBoxHeight*GFX_SCALE*4 / 100;
		}
		
		override public function logicUpdate():void
		{
			//trace(isOnground + " mPlayerDY "+mPlayerDY);
			var impulse:b2Vec2 = new b2Vec2(mPlayerDX * 0.01, -mPlayerDY * 0.1);
			var point:b2Vec2 = new b2Vec2(0 , 0);	
			mBody.SetAngle(0);
			mBody.SetAngularVelocity(0);
			mBody.SetPositionAndAngle(mBody.GetPosition(), 0);
			
			var v:b2Vec2 = mBody.GetLinearVelocity();
			if (mPlayerDX != 0)
			{
				if (mIsOnground)
				{
					v.x = mPlayerDX * 3;
				}
				else
				{
					v.x = mPlayerDX * 2;
				}
				//
			}
			if (mPlayerDY != 0 && mIsOnground)
			{			
				v.y = -8.0				
			}
			mBody.SetLinearVelocity(v);
			mBody.ApplyImpulse(impulse, point);
		
			//
			mPlayerDY = 0;		
			
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
			
			
			// Level
			switch(smDestructivePower)
			{
				case 1: if (smDestroyedCount > 12) smDestructivePower++; break;
				case 2: if (smDestroyedCount > 25) smDestructivePower++; break;
				case 3: if (smDestroyedCount > 40) smDestructivePower++; break;
				case 4: if (smDestroyedCount > 55) smDestructivePower++; break;
				case 5: if (smDestroyedCount > 65) smDestructivePower++; break;
				case 6: if (smDestroyedCount > 75) smDestructivePower++; break;
			}
			
			
			// Render
			if (mIsOnground)
			{
				mCurrentFrameCounter -= Math.abs(v.x);
			}
			
			if (mCurrentFrameIndex > 4 && v.x > 0) mCurrentFrameCounter = -1;
			if (mCurrentFrameIndex <= 4 && v.x < 0) mCurrentFrameCounter = -1;	
				
				if (mCurrentFrameCounter < 0)
				{
					mCurrentFrameCounter = 10;
					removeChild(mCurrentFrame);
					mCurrentFrameIndex++;
					if (mCurrentFrameIndex > 4 && v.x > 0) mCurrentFrameIndex = 1;
					if (mCurrentFrameIndex > 7 && v.x < 0) mCurrentFrameIndex = 5;
					mCurrentFrame = mFrames[mCurrentFrameIndex];
					mCurrentFrame.x = -100/2;
					mCurrentFrame.y = -100/2;
					addChildAt(mCurrentFrame, 0);
				}
				if (Math.abs(v.x) + Math.abs(v.y) < 0.2)
				{
					removeChild(mCurrentFrame);
					mCurrentFrameIndex = 0;
					mCurrentFrame = mFrames[mCurrentFrameIndex];
					mCurrentFrame.x = -100/2;
					mCurrentFrame.y = -100/2;
					addChildAt(mCurrentFrame, 0);
				}
			
			
			
			x = (mBody.GetWorldCenter().x *GFX_SCALE);
			y = ((mBody.GetWorldCenter().y )*GFX_SCALE);
			y -= 20;
			//width = boxWidth*GFX_SCALE*2;
			//height = boxHeight*GFX_SCALE*2;
			scaleX = mGfxScaleX;
			scaleY = mGfxScaleY;
		}
		
		
		
		private var mPlayerX:Number;
		private var mPlayerY:Number;
		private var mPlayerDX:int;
		private var mPlayerDY:int;
		private var mPlayerSX:Number;
		private var mPlayerSY:Number;
		private var mPlayerFire:int;
		private var mPlayerAngle:Number;
		private var mPlayerHeight:Number;
		private var coolDownY:int = 0;
		
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT)
			{
				mPlayerDX = 1;
				//mPlayerSprite.scaleX = 1;
			}
			if (e.keyCode == Keyboard.LEFT)
			{
				mPlayerDX = -1;
				//mPlayerSprite.scaleX = -1;
			}
			if (e.keyCode == Keyboard.UP && mIsOnground && coolDownY == 0)
			{
				mPlayerDY = 1;
				coolDownY = 1;
				
			}
			if (e.keyCode == Keyboard.SPACE)
			{
				mPlayerFire = 1;
				
			}
		}
		
		
		public function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT)
			{
				mPlayerDX = 0;
			}
			if (e.keyCode == Keyboard.LEFT)
			{
				mPlayerDX = 0;
			}
			if (e.keyCode == Keyboard.UP)
			{
				mPlayerDY = 0;		
				coolDownY = 0;
			}
			if (e.keyCode == Keyboard.SPACE)
			{
				mPlayerFire = 0;
			}					
		}
	}
}