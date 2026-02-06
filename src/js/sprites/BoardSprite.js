import * as PIXI from 'pixi.js';

/**
 * Animated board tile sprite
 * Converted from ActionScript BoardSprite.as
 */
export default class BoardSprite extends PIXI.Container {
    static ALPHAS = [0.0, 0.33, 0.66, 1.0];

    constructor(textures) {
        super();
        this._hit = 3;
        this._textures = textures;
        this._animatedSprite = null;
        this._isAnimating = false;
        
        this.createAnimatedSprite();
    }

    createAnimatedSprite() {
        // Create animated sprite from textures
        this._animatedSprite = new PIXI.AnimatedSprite(this._textures);
        this._animatedSprite.x = Math.ceil(-this._animatedSprite.width / 2);
        this._animatedSprite.y = Math.ceil(-this._animatedSprite.height / 2);
        this._animatedSprite.loop = false;
        this._animatedSprite.animationSpeed = 1; // 60 FPS
        this.addChild(this._animatedSprite);
    }

    animate() {
        if (!this._isAnimating) {
            this._isAnimating = true;
            this._animatedSprite.gotoAndPlay(0);
            this._animatedSprite.onComplete = () => {
                this.onAnimationOver();
            };
        }
    }

    applyHit() {
        if (this._animatedSprite) {
            this._animatedSprite.alpha = BoardSprite.ALPHAS[this._hit];
        }
    }

    onAnimationOver() {
        this._isAnimating = false;
        this._animatedSprite.stop();
        this._animatedSprite.alpha = BoardSprite.ALPHAS[this._hit];
    }

    get hit() {
        return this._hit;
    }

    set hit(value) {
        this._hit = value;
    }
}
