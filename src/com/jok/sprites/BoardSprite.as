package com.jok.sprites
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class BoardSprite extends Sprite {
		
		public static const ALPHAS : Array = [0.0, 0.33, 0.66, 1.0];
		
		
		private var _hit : Number = 3;
		private var _animatedSprite : MovieClip;
		private var _textures : Vector.<Texture>;
		
		public function BoardSprite(textures : Vector.<Texture>) {
			super();
			this._textures = textures;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage() : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createAnimatedSprite();
		}
		
		public function createAnimatedSprite() : void {
			animatedSprite = new MovieClip(_textures, 60);
			animatedSprite.x = Math.ceil(-animatedSprite.width/2);
			animatedSprite.y = Math.ceil(-animatedSprite.height/2);
			animatedSprite.loop = false;
			this.addChild(animatedSprite);
		}
		
		public function animate() : void {
			if (!starling.core.Starling.juggler.contains(animatedSprite)) {
				starling.core.Starling.juggler.add(animatedSprite);
				animatedSprite.addEventListener(Event.COMPLETE, onAnimationOver);
				animatedSprite.play();
			}
		}
		
		public function applyHit() : void {
			animatedSprite.alpha = BoardSprite.ALPHAS[_hit];
		}
		
		private function onAnimationOver() : void {
			starling.core.Starling.juggler.remove(animatedSprite);
			animatedSprite.removeEventListener(Event.COMPLETE, onAnimationOver);
			animatedSprite.stop();
			animatedSprite.alpha = BoardSprite.ALPHAS[_hit];
			
		}
		
		public function get animatedSprite() : MovieClip {
			return _animatedSprite;
		}

		public function set animatedSprite(value : MovieClip) : void {
			_animatedSprite = value;
		}

		public function get hit() : Number {
			return _hit;
		}

		public function set hit(value : Number) : void {
			_hit = value;
		}


	}
}