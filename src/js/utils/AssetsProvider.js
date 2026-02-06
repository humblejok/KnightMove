import * as PIXI from 'pixi.js';

/**
 * Provides access to game assets (textures, sprite sheets)
 * Converted from ActionScript AssetsProvider.as
 */
class AssetsProvider {
    constructor() {
        this.textures = {};
        this.animatedWhiteAtlas = null;
        this.animatedBlackAtlas = null;
        this.loader = null;
    }

    /**
     * Load all game assets
     * @returns {Promise} Promise that resolves when all assets are loaded
     */
    async loadAssets() {
        const assets = [
            { name: 'chessKing', url: '/assets/ChessKing.png' },
            { name: 'backGround', url: '/assets/BackGround.png' },
            { name: 'whiteBoard', url: '/assets/WhiteBoard.png' },
            { name: 'blackBoard', url: '/assets/BlackBoard.png' },
            { name: 'chessKnight', url: '/assets/ChessKnight.png' },
            { name: 'chessBlob', url: '/assets/ChessBlob.png' },
            { name: 'pause', url: '/assets/Pause.png' },
            { name: 'target', url: '/assets/Target.png' },
            { name: 'whiteTextures', url: '/assets/white-starling.png' },
            { name: 'blackTextures', url: '/assets/black-starling.png' },
            { name: 'whiteXml', url: '/assets/white-starling.xml' },
            { name: 'blackXml', url: '/assets/black-starling.xml' }
        ];

        // Load all assets
        for (const asset of assets) {
            try {
                if (asset.url.endsWith('.xml')) {
                    // Load XML as text
                    const response = await fetch(asset.url);
                    this.textures[asset.name] = await response.text();
                } else {
                    // Load as texture
                    this.textures[asset.name] = await PIXI.Assets.load(asset.url);
                }
            } catch (error) {
                console.error(`Failed to load asset: ${asset.name}`, error);
            }
        }

        // Create sprite sheets for animated board tiles
        await this.createAnimatedAtlases();
    }

    /**
     * Create texture atlases for animated board sprites
     */
    async createAnimatedAtlases() {
        // Parse XML for white tiles
        if (this.textures['whiteXml']) {
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(this.textures['whiteXml'], 'text/xml');
            this.animatedWhiteAtlas = this.createAtlasFromXml(
                this.textures['whiteTextures'],
                xmlDoc
            );
        }

        // Parse XML for black tiles
        if (this.textures['blackXml']) {
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(this.textures['blackXml'], 'text/xml');
            this.animatedBlackAtlas = this.createAtlasFromXml(
                this.textures['blackTextures'],
                xmlDoc
            );
        }
    }

    /**
     * Create texture atlas from XML sprite sheet definition
     */
    createAtlasFromXml(baseTexture, xmlDoc) {
        const atlas = {};
        const subtextures = xmlDoc.getElementsByTagName('SubTexture');
        
        for (let i = 0; i < subtextures.length; i++) {
            const st = subtextures[i];
            const name = st.getAttribute('name');
            const x = parseInt(st.getAttribute('x'));
            const y = parseInt(st.getAttribute('y'));
            const width = parseInt(st.getAttribute('width'));
            const height = parseInt(st.getAttribute('height'));
            
            const rect = new PIXI.Rectangle(x, y, width, height);
            atlas[name] = new PIXI.Texture(baseTexture, rect);
        }
        
        return atlas;
    }

    /**
     * Get a texture by name
     */
    getAsTexture(name) {
        return this.textures[name];
    }

    /**
     * Get animated white board textures
     */
    getAnimatedWhite() {
        return this.animatedWhiteAtlas;
    }

    /**
     * Get animated black board textures
     */
    getAnimatedBlack() {
        return this.animatedBlackAtlas;
    }

    /**
     * Get textures for animation by prefix
     */
    getTexturesByPrefix(atlas, prefix) {
        const textures = [];
        for (const name in atlas) {
            if (name.startsWith(prefix)) {
                textures.push(atlas[name]);
            }
        }
        // Sort by name to ensure correct order
        textures.sort((a, b) => {
            const aNum = parseInt(a.textureCacheIds[0].match(/\d+/)?.[0] || 0);
            const bNum = parseInt(b.textureCacheIds[0].match(/\d+/)?.[0] || 0);
            return aNum - bNum;
        });
        return textures;
    }
}

// Create singleton instance
const assetsProvider = new AssetsProvider();
export default assetsProvider;
