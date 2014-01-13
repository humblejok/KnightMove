package com.jok.sprites
{
	import com.jok.utils.AssetsProvider;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BlackSprite extends Sprite {
		
		private var animatedSprite : MovieClip;
		
		public function BlackSprite() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage() : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createAnimatedSprite();
		}
		
		private function createAnimatedSprite():void {
			animatedSprite = new MovieClip(AssetsProvider.getAnimatedBlack().getTextures("black_"), 60);
			animatedSprite.x = Math.ceil(-animatedSprite.width/2);
			animatedSprite.y = Math.ceil(-animatedSprite.height/2);
			
			this.addChild(animatedSprite);
		}		
		
		public function animate() : void {
			starling.core.Starling.juggler.add(animatedSprite);
		}
		
		public function freeze() : void {
			starling.core.Starling.juggler.remove(animatedSprite);
		}
		
	}
}