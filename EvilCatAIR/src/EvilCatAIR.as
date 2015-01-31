package
{
	///////////////////////////////////////////////////////////////////////////////////////////
	// Evil Cat
	// Evolution game for Ludum Dare
	// Author: Carlos Peris
	// Date: 15/12/2012
	///////////////////////////////////////////////////////////////////////////////////////////
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	[SWF(width=6400, height=4800, backgroundColor='0x2A98FE', frameRate='50', allowScriptAccess='always', allowfullscreen='true')]
	public class EvilCatAIR extends Sprite
	{
		public static const DEBUG:Boolean = false;
		public static const SCREEN_WIDTH:int = 640;
		public static const SCREEN_HEIGHT:int = 480;
		
		
		private var mDate:Date = new Date();
		
		[Embed(source="data/background.png")]
		private static const gfxBackground:Class;
		
		[Embed(source="data/hud.png")]
		private static const gfxHUD:Class;
		
		[Embed(source="data/sofa.png")]
		private static const gfxSofa:Class;
		
		[Embed(source="data/minilamp.png")]
		private static const gfxMiniLamp:Class;
		
		[Embed(source="data/lamp.png")]
		private static const gfxLamp:Class;
		
		[Embed(source="data/bedside.png")]
		private static const gfxBedside:Class;
		
		
		[Embed(source="data/redbook.png")]
		private static const gfxRedBook:Class;
		[Embed(source="data/bluebook.png")]
		private static const gfxBlueBook:Class;
		[Embed(source="data/greenbook.png")]
		private static const gfxGreenBook:Class;
		
		[Embed(source="data/trophy.png")]
		private static const gfxTrophy:Class;
		
		[Embed(source="data/chest.png")]
		private static const gfxChest:Class;
		
		[Embed(source="data/computer.png")]
		private static const gfxComputer:Class;
		
		[Embed(source="data/wash.png")]
		private static const gfxWashingMachine:Class;
		
		[Embed(source="data/ball.png")]
		private static const gfxBall:Class;
		
		[Embed(source="data/dialog.png")]
		private static const gfxDialog:Class;
		
		
		private var score:int = 0;
		private var topScore:int = 0;
		
		private var mGameTime:Number;
		
		
		private var mMessageTextfield:TextField = new TextField();
		private var mScoreTextfield:TextField = new TextField();
		private var mPowerTextfield:TextField = new TextField();
		private var mTopScoreTextfield:TextField = new TextField();
		private var mObjectsLeftTextfield:TextField = new TextField();
		
		private var mDialogSprite:Sprite = new Sprite;
		
		private var mElements:Array = new Array();
		
		private var mObjectsToDestroyCount:int = 0;
		private var mMessageTimer:int = 0;
	
		
		private var mMessages:Array = [
			"MEOW",
			"MEOW!!!",
			"FELL OFF ALL BY ITSELF",
			"IT WASN'T ME",
			"GOOD CAT",
			"KILL ALL HUMANS",
			"DESTROY!",
			"IT WAS MY TWIN BROTHER",
			"FUNNY, ISN'T IT",
			"LET'S EXPLORE A BIT MORE",
			"MEOW, MEOW, MEOW",
			"GIVE ME A KEYBOARD",
			"DON'T GET A DOG PLEASE",
			"THIS WAS MINE",
			"YOU SHOULD BUY ANOTHER ONE",
			"I NEVER LIKED IT",
			"IT WAS NOT ITS PLACE",
			"I DIDN'T MEANT IT",
			"DESTROY EVERYTHING",
			"MUCH BETTER NOW",
			"SO MANY THINKS TO BREAK",
			"YOU NEVER USED IT ANYWAY",
			"IT WAS BROKEN ALREADY",
			"I LIKE TO SCRATCH BOOKS",
			"MEOW!"
		];
		
		
		public var mWorld:b2World;
		public var mTimeStep:Number = 1.0/30.0;
		public var mVelocityIterations:int = 10;
		public var mPositionIterations:int = 10;		
		public var mCat:Cat = new Cat();

		
		
		
		
	
		
		public function EvilCatAIR()
		{
			var back:Bitmap = new gfxBackground as Bitmap;
			
			back.x = -200;
			back.y = -200;
			back.scaleX = Element.GFX_SCALE / 50;
			back.scaleY = Element.GFX_SCALE / 50;
			addChildAt(back, 0);
				
			
			mGameTime = currentTimeMillis();
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 16;
			myFormat.font = "Times New Roman";
			myFormat.align = TextFormatAlign.CENTER;
			
			mMessageTextfield.defaultTextFormat = myFormat;				
			mMessageTextfield.y = 14;
			
			mMessageTextfield.textColor = 0x0;
			mMessageTextfield.width = 153;
			mMessageTextfield.height = 65;
			mMessageTextfield.wordWrap = true;
			
			mTopScoreTextfield.textColor = 0xffffff;
			mTopScoreTextfield.defaultTextFormat = myFormat;	
			mTopScoreTextfield.x = 16;
			mTopScoreTextfield.y = 12+20;
			mTopScoreTextfield.width = 430;
			
			myFormat.align = TextFormatAlign.LEFT;				
			mScoreTextfield.textColor = 0x6B351B;
			mScoreTextfield.defaultTextFormat = myFormat;	
			mScoreTextfield.x = 16;
			mScoreTextfield.y = 8;
			mScoreTextfield.width = 430;
			
			mPowerTextfield.textColor = 0x6B351B;
			mPowerTextfield.defaultTextFormat = myFormat;	
			mPowerTextfield.x = 16;
			mPowerTextfield.y = 28;
			mPowerTextfield.width = 430;
			
			mObjectsLeftTextfield.textColor = 0xfB351B;
			mObjectsLeftTextfield.defaultTextFormat = myFormat;	
			mObjectsLeftTextfield.x = SCREEN_WIDTH - 140;
			mObjectsLeftTextfield.y = 8;
			mObjectsLeftTextfield.width = 430;
			
			
			init();
			
			
			var hud:Bitmap = new gfxHUD as Bitmap;
			stage.addChild(hud);
			stage.addChild(mTopScoreTextfield);
			stage.addChild(mPowerTextfield);
			stage.addChild(mScoreTextfield);		
			stage.addChild(mObjectsLeftTextfield);		
			
			
			mMessageTextfield.text = "USE CURSOR KEYS TO CONTROL ME";
			mMessageTimer = 7000;
		}
		
		
	
		
		
		
				
		
		
		
		private function init():void
		{
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(-1000.0, -1000.0);
			environment.upperBound.Set(1000.0, 1000.0);
			var gravity:b2Vec2=new b2Vec2(0.0, 10.0);
			mWorld = new b2World(gravity, true);
			mWorld.SetWarmStarting(true);
			

			

			
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			if (DEBUG) addChild(debug_sprite);
			
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(Element.GFX_SCALE);
			debug_draw.SetFillAlpha(0.3);
			debug_draw.SetLineThickness(1.0);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			mWorld.SetDebugDraw(debug_draw);

			// Create border of boxes
			var wall:b2PolygonShape= new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			// Left
			wallBd.position.Set( -95 / Element.m_physScale, 460 / Element.m_physScale / 2);
			wall.SetAsBox(100/Element.m_physScale, 500/Element.m_physScale/2);
			wallB = mWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			// Right
			wallBd.position.Set((640 + 95) / Element.m_physScale, 460 / Element.m_physScale / 2);
			wallB = mWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			// Top
			wallBd.position.Set(640 / Element.m_physScale / 2, -95 / Element.m_physScale);
			wall.SetAsBox(680/Element.m_physScale/2, 100/Element.m_physScale);
			wallB = mWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			// Bottom
			wallBd.position.Set(640 / Element.m_physScale / 2, (460 + 95) / Element.m_physScale);
			wallB = mWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
	
			addPlatform(300, getFloorY(5), 600);
			for(var i:int = 0; i < 4; i += 2)
			{
				addPlatform(130, getFloorY(i+1), 130);
				addPlatform(312, getFloorY(i+1.5), 15, 3);
				addPlatform(500, getFloorY(i+2), 140);
				if (i < 2) addPlatform(312, getFloorY(i+2.5), 15, 3);
			}
				
			
			
			//FLOOR 5
			addBed(120, getFloorY(5))
			addTable(550, getFloorY(5) );
			addVase(550, getFloorY(5) -12);
			addTable(40, getFloorY(5) );			
			
			addPlatform(160, getFloorY(4), 30, 2);
			
			addBookPlatform(60, getFloorY(4));		
			
			addTrophy(140, getFloorY(4));
			for(i= 0; i < 3; i++)
			{
				addBook(160+ (i*5),	getFloorY(4));
			}						
			addWashingMachine(300, getFloorY(5));			
			addChest(240, getFloorY(5));
			addVase(240, getFloorY(5)-12);
			addMiniLamp(50, getFloorY(5)-20);
			
			//FLOOR 4
			addTable(600, getFloorY(4) );
			
			addComputer(600, getFloorY(4) -30);
			addTft(600, getFloorY(4) -34);
			addChest(440, getFloorY(4));
			addTrophy(440, getFloorY(4)-12);
			addLamp(540, getFloorY(4));
			addBookPlatform(460, getFloorY(3))
			addBookPlatform(560, getFloorY(3)-30)
			addVase(470, getFloorY(3) - 2);
			addVase(480, getFloorY(3) - 2);
			addVase(580, getFloorY(3) - 32);
			
			addBall(580, getFloorY(3) +32);
			
			//FLOOR 3
			addSofa(100, getFloorY(3));
			addLamp(140, getFloorY(3));
			addChest(200, getFloorY(3));
			addPlasma(200, getFloorY(3)-30);
			addBookPlatform(60, getFloorY(2)-20)
			addBedsideTable(40, getFloorY(3));
			addVase(80, getFloorY(2)-30);
			
			//FLOOR 2
			addTable(550, getFloorY(2));
			addTable(450, getFloorY(2));
			addTft(550, getFloorY(2) - 62);
			addPlasma(450, getFloorY(2) - 62);
			addWashingMachine(400, getFloorY(2));
			addBookPlatform(560, getFloorY(1))			
			addMiniLamp(580, getFloorY(1));
			
			addPlatform(460, getFloorY(1)-30, 30, 2);									
			addBook(440, getFloorY(1)-30);
			for(i= 0; i < 3; i++)
			{
				addTrophy(460+ (i*10),	getFloorY(1)-30);
			}				
			
			addBall(450, getFloorY(1) -30);
			
			//FLOOR 1			
			addLamp(40, getFloorY(1));
			addBed(150, getFloorY(1))
			
			//addChest(200, getFloorY(1));
			//addTft(200, getFloorY(1)-30);
			addBedsideTable(230, getFloorY(1));
			addMiniLamp(230, getFloorY(1)-12);
			
			//mWorld.SetBroadPhase(new b2BroadPhase(environment));
			
			mMessageTextfield.text = "MIAU";
			
			mCat.init(mWorld, 100, getFloorY(3)-20, 8, 8);
			var dialog:Bitmap = new gfxDialog as Bitmap;
			
			mDialogSprite.addChild(dialog);
			mDialogSprite.addChild(mMessageTextfield);
			mDialogSprite.x = -74;
			mDialogSprite.y = -100;
			mCat.addChild(mDialogSprite);
			
			addChild(mCat);
			mCat.setMass(3);
			mElements.push(mCat);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, mCat.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, mCat.onKeyUp);
			
			this.addEventListener(Event.ENTER_FRAME, logicUpdate);
		}
		
		
		
		public function addBookPlatform(_x:int, _y:int):void 
		{
			addPlatform(_x, _y, 30, 2);
			for(var i:int = 0; i < 6; i++)
			{
				addBook(_x - 20 + (i*5),	_y);
			}
		}
		
		
		
		private function onMouseClick(event:MouseEvent = null):void 
		{
			
		}
		

		
		
		
	
		
		
		
		
		
		
		private function logicUpdate(event:Event):void 
		{			
			//trace("* elements "+elements.length);
			
			var timeMillis:Number = currentTimeMillis();
			var dt:int = timeMillis - mGameTime;
			mGameTime = timeMillis;
			
			
			var damageLevel:int = 0;
			mObjectsToDestroyCount = 0;
			for(var i:int; i < mElements.length; i++)
			{					
				var e:Element = mElements[i]; 
				if (e.mBrokenThreshold > 0) mObjectsToDestroyCount++;
				e.logicUpdate();
				if (e.mFallenDown)
				{
					damageLevel = Math.max(damageLevel, 1);
				}
				if (e.mDestroyMe)
				{
					if (e.mTimeToLife == 0)
					{
						damageLevel = Math.max(damageLevel, 2);					
						addParticles(e);
					}
					removeChild(mElements[i]);
					mWorld.DestroyBody(e.mBody);					
					mElements.splice(i, 1);
				}
				
			}
			if (mObjectsToDestroyCount == 0)
			{
				mDialogSprite.visible = true;
				mDialogSprite.alpha = 1;
				mCat.setChildIndex(mDialogSprite, 0);
				mMessageTextfield.text = "GAME OVER. CONGRATS!";
				mMessageTimer = 30000;
			}
			
			
			mWorld.Step(mTimeStep, mVelocityIterations, mPositionIterations);
			mWorld.ClearForces();
			
			
			
			// Render
			var tx:Number = (SCREEN_WIDTH/2) - mCat.x;
			var ty:Number = (SCREEN_HEIGHT/2) - mCat.y;
			
			x = x - ((x - tx) / 10);
			y = y - ((y - ty) / 10);
			
			if (Math.abs(tx-x) > SCREEN_WIDTH || Math.abs(ty-y) > SCREEN_HEIGHT)
			{
				x=tx;
				y=ty;
			}
			
			
			if (DEBUG) mWorld.DrawDebugData();

			mScoreTextfield.text = "EVILNESS: "+(int)(Cat.smEvilness/1000);
			mPowerTextfield.text = "CAT POWER: "+(int)(Cat.smDestructivePower);
			mObjectsLeftTextfield.text = "OBJECTS LEFT: "+mObjectsToDestroyCount;
			
			if (mMessageTimer >= 0 )
			{
				mMessageTimer  -= dt;
				
			}
			else
			{
				mDialogSprite.alpha -= 0.05;
				if (mDialogSprite.alpha <= 0)
				{
					mDialogSprite.visible = false;
				}
				
				if (Cat.smEvilness - Cat.smPrevEvilness >= 2000)
				{
					mDialogSprite.visible = true;
					mDialogSprite.alpha = 1;
					mCat.setChildIndex(mDialogSprite, 0);
					mMessageTextfield.text = mMessages[(int)(Math.random()*(mMessages.length-1))];
					mMessageTimer = 3000;
				}
				Cat.smPrevEvilness = Cat.smEvilness;	
			}
		}
		
		private function addParticles(e:Element):void 
		{	
			for(var i:int = 0; i < 8;i++)
			{
				addParticle(e, e.mBody.GetWorldCenter().x, e.mBody.GetWorldCenter().y);
			}
		}
		
		public function addParticle(e:Element, _x:Number = 0, _y:Number = 0):void
		{
			var p:EleParticle = new EleParticle();
			p.init(mWorld, (_x * Element.m_physScale) + Math.random(), (_y* Element.m_physScale) + Math.random(), (3.0- Math.random()*2)*e.width/Element.GFX_SCALE, (3.0- Math.random()*2)*e.height/Element.GFX_SCALE);
			p.loadGfxFromSprite(e as Sprite);
			p.mBody.SetAngularVelocity(e.mBody.GetAngularVelocity());
			p.mBody.SetLinearVelocity(e.mBody.GetLinearVelocity());
			p.mBody.SetAngle(Math.random()*Math.PI);
			p.mTimeToLife = 100 + (Math.random()*200);
			//p.setMass(e.getMass()/10);
			addChild(p);
			
			mElements.push(p);
		}
		
		
		public function addTft(_x:int = 0, _y:int = 0):void
		{
			_y - 12;
			var b:EleTft = new EleTft();
			b.init(mWorld, _x, _y, 12, 12);
			b.loadGfx();
			addChild(b);			
			mElements.push(b);
		}
		
		
		public function addPlasma(_x:int = 0, _y:int = 0):void
		{
			_y - 15;
			var b:EleTft = new EleTft();
			b.init(mWorld, _x, _y, 24, 15);
			b.loadGfx();
			addChild(b);			
			mElements.push(b);
			b.mBrokenThreshold = 300;
		}
		
		
		public function addBed(_x:int = 0, _y:int = 0):void
		{
			_y -= 15;
			var b:EleBed = new EleBed();
			b.init(mWorld, _x, _y, 35, 12);
			b.loadGfx();
			b.setMass(8);
			addChild(b);			
			mElements.push(b);
		}
		
		
		public function addTable(_x:int = 0, _y:int = 0):void
		{
			var b:EleWood;
			
			_y -= 10;
			
			b = new EleWood();
			b.init(mWorld, _x-20+5, _y, 6, 10);
			b.loadGfx();
			b.setMass(1);
			addChild(b);			
			mElements.push(b);
			
			b = new EleWood();
			b.init(mWorld, _x+20-5, _y, 6, 10);
			b.loadGfx();
			b.setMass(1);
			addChild(b);			
			mElements.push(b);
			
			
			_y -= 2;
			
			var z:EleWood = new EleWood();
			z.init(mWorld, _x, _y, 30, 3);
			z.loadGfx();
			z.setMass(1);
			addChild(z);		
			
			mElements.push(z);
			
		}
		
		
		public function addVase(_x:int = 0, _y:int = 0):void
		{
			var b:EleVase = new EleVase();
			b.init(mWorld, _x, _y, 5, 10);
			b.loadGfx();
			addChild(b);
			b.setMass(0.3);
			
			mElements.push(b);
		}
		
		
		public function addBook(_x:int = 0, _y:int = 0):void
		{
			var bookHeight:int = 4 + (Math.random()*4);
			_y -= bookHeight;
			
			var color:int = Math.random()*3;
			var gfx:Bitmap;
			switch(color)
			{
				case 1: gfx = new gfxBlueBook as Bitmap; break;
				case 2:	gfx = new gfxGreenBook as Bitmap; break;
				default: gfx = new gfxRedBook as Bitmap; break;
			}
			
			var b:Element = new Element(gfx);
			b.init(mWorld, _x, _y, 2, bookHeight);
			b.loadGfx();
			addChild(b);
			b.setMass(0.2);
			b.mBrokenThreshold = 2000;
			
			mElements.push(b);
		}
		
		
		public function addTrophy(_x:int = 0, _y:int = 0):void
		{
			_y -= 8;
			var b:Element = new Element(new gfxTrophy as Bitmap);
			b.init(mWorld, _x, _y, 6, 12);
			b.loadGfx();
			addChild(b);
			b.setMass(0.4);
			b.mBrokenThreshold = 200;
			
			mElements.push(b);
		}
		
		
		public function addSofa(_x:int = 0, _y:int = 0):void
		{
			_y -= 8;
			var b:Element = new Element(new gfxSofa as Bitmap);
			b.init(mWorld, _x, _y, 35, 15);
			b.loadGfx();
			addChild(b);
			b.setMass(10.0);
			b.mBrokenThreshold = 5000;
			
			mElements.push(b);
		}
		
		
		public function addLamp(_x:int = 0, _y:int = 0):void
		{
			_y -= 25;
			var b:Element = new Element(new gfxLamp as Bitmap);
			b.init(mWorld, _x, _y, 8, 25);
			b.loadGfx();
			addChild(b);
			b.setMass(2.0);
			b.mBrokenThreshold = 1000;
			
			mElements.push(b);
		}
		
		
		public function addMiniLamp(_x:int = 0, _y:int = 0):void
		{
			_y -= 10;
			var b:Element = new Element(new gfxMiniLamp as Bitmap);
			b.init(mWorld, _x, _y, 12, 10);
			b.loadGfx();
			addChild(b);
			b.setMass(0.8);
			b.mBrokenThreshold = 600;
			
			mElements.push(b);
		}
		
		
		
		public function addBedsideTable(_x:int = 0, _y:int = 0):void
		{
			_y -= 10;
			var b:Element = new Element(new gfxBedside as Bitmap);
			b.init(mWorld, _x, _y, 12, 12);
			b.loadGfx();
			addChild(b);
			b.setMass(1.0);
			b.mBrokenThreshold = 600;
			
			mElements.push(b);
		}
		
		
		public function addChest(_x:int = 0, _y:int = 0):void
		{
			_y -= 12;
			var b:Element = new Element(new gfxChest as Bitmap);
			b.init(mWorld, _x, _y, 24, 12);
			b.loadGfx();
			addChild(b);
			b.setMass(6);
			b.mBrokenThreshold = 2000;
			
			mElements.push(b);
		}
		
		
		public function addComputer(_x:int = 0, _y:int = 0):void
		{
			_y -= 4;
			var b:Element = new Element(new gfxComputer as Bitmap);
			b.init(mWorld, _x, _y, 12, 4);
			b.loadGfx();
			addChild(b);
			b.setMass(4);
			b.mBrokenThreshold = 500;
			
			mElements.push(b);
		}
		
		
		public function addBall(_x:int = 0, _y:int = 0):void
		{
			_y -= 15;
			var b:EleBall = new EleBall(new gfxBall as Bitmap);
			b.init(mWorld, _x, _y, 5, 5);
			b.loadGfx();
			addChild(b);
			b.setMass(0.1);
			//b.brokenThreshold = 5000;
			
			mElements.push(b);
		}
		
		
		public function addWashingMachine(_x:int = 0, _y:int = 0):void
		{
			_y -= 20;
			var b:EleWashingMachine = new EleWashingMachine(new gfxWashingMachine as Bitmap);
			b.init(mWorld, _x, _y, 15, 18);
			b.loadGfx();
			addChild(b);
			b.setMass(50);
			b.mBrokenThreshold = 10000;
			
			mElements.push(b);
		}
		
		
		
		public function addBox(_x:int = 0, _y:int = 0, _width:int = 10, _height:int = 10):void
		{
			
		
			var b:Element = new Element();
			b.init(mWorld, _x, _y, _width, _height);
			b.loadGfx();
			addChild(b);
			
			mElements.push(b);
		}
		

		public function addPlatform(_x:int = 0, _y:int = 0, _width:int = 100, _height:int = 5):void
		{
			var b:Element = new Element();
			b.init(mWorld, _x, _y, _width, _height, true);
			b.loadGfx();
			addChild(b);
			
			mElements.push(b);			
		}

		public function getFloorY(i:Number):Number
		{
			return i*65;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		
		
		public function currentTimeMillis():Number
		{
			mDate = new Date();
			return mDate.getTime();
		}
		
	}
}