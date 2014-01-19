package com.jok.element
{
	import com.jok.sprites.Board;
	import com.jok.utils.AssetsProvider;
	
	import starling.textures.Texture;
	
	public class TargetElement extends Element {
		public function TargetElement(parent:Board, row:Number, column:Number, texture:Texture=null, resize:Boolean=true) {
			super(parent, row, column, AssetsProvider.getAsTexture("target"));
		}
	}
}