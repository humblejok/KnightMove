import BoardSprite from '../sprites/BoardSprite.js';
import AssetsProvider from '../utils/AssetsProvider.js';

/**
 * Board tile element that can be damaged and repaired
 * Converted from ActionScript BoardElement.as
 */
export default class BoardElement {
    constructor(board, row, column) {
        this.size = 90;
        this._column = column;
        this._row = row;
        this._board = board;
        
        // Create animated sprite based on position (checkerboard pattern)
        const isWhite = (row + column) % 2 === 1;
        const atlas = isWhite ? 
            AssetsProvider.getAnimatedWhite() : 
            AssetsProvider.getAnimatedBlack();
        
        // Get textures for animation
        const prefix = isWhite ? 'white_' : 'black_';
        const textures = this.getTexturesFromAtlas(atlas, prefix);
        
        this.animatedSprite = new BoardSprite(textures);
        this.displayOnBoard();
    }

    getTexturesFromAtlas(atlas, prefix) {
        const textures = [];
        for (const name in atlas) {
            if (name.startsWith(prefix)) {
                textures.push(atlas[name]);
            }
        }
        // Sort textures by frame number
        textures.sort((a, b) => {
            const getFrameNum = (tex) => {
                const match = tex.textureCacheIds?.[0]?.match(/\d+/) || 
                              Object.keys(tex)[0]?.match(/\d+/);
                return match ? parseInt(match[0]) : 0;
            };
            return getFrameNum(a) - getFrameNum(b);
        });
        return textures;
    }

    displayOnBoard() {
        this.animatedSprite.x = this.convertColumnToPosition(this._column) + 
                                Math.floor(this.size / 2);
        this.animatedSprite.y = this.convertRowToPosition(this._row) + 
                                Math.floor(this.size / 2);
    }

    get hit() {
        return this.animatedSprite.hit;
    }

    elementHit() {
        this.animatedSprite.hit -= 1;
        if (this.animatedSprite.hit === 0) {
            this._board.scoreValue += 50;
        }
        this.animatedSprite.animate();
    }

    repair(complete = false) {
        if (!complete) {
            if (this.animatedSprite.hit === 0) {
                this.animatedSprite.hit = 1;
                this._board.scoreValue += 50;
            }
        } else {
            this.animatedSprite.hit = 3;
        }
        this.animatedSprite.applyHit();
        this.animatedSprite.animate();
    }

    convertRowToPosition(r) {
        const boardHeight = this._board.constructor.boardHeight;
        return ((600 - boardHeight * this.size) / 2) + (r * this.size);
    }

    convertColumnToPosition(c) {
        const boardWidth = this._board.constructor.boardWidth;
        return ((800 - boardWidth * this.size) / 2) + (c * this.size);
    }
}
