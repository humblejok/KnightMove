import * as PIXI from 'pixi.js';
import AssetsProvider from './utils/AssetsProvider.js';
import Game from './sprites/Game.js';
import { initializeMobile } from './utils/MobileInit.js';

/**
 * Main application entry point
 * Converted from ActionScript KnightMove.as
 */

// Create PixiJS application
const app = new PIXI.Application({
    width: 800,
    height: 600,
    backgroundColor: 0x333333,
    antialias: true,
    resolution: window.devicePixelRatio || 1,
    autoDensity: true
});

// Add canvas to DOM
document.getElementById('game-container').appendChild(app.view);

// Show loading text
const loadingText = new PIXI.Text('Loading...', {
    fontFamily: 'Arial',
    fontSize: 48,
    fill: 0xFFFFFF,
    align: 'center'
});
loadingText.x = app.screen.width / 2 - loadingText.width / 2;
loadingText.y = app.screen.height / 2 - loadingText.height / 2;
app.stage.addChild(loadingText);

// Load assets and start game
async function init() {
    try {
        // Initialize mobile features (Android/iOS)
        await initializeMobile();
        
        console.log('Loading assets...');
        await AssetsProvider.loadAssets();
        console.log('Assets loaded!');
        
        // Remove loading text
        app.stage.removeChild(loadingText);
        
        // Create and start game
        const game = new Game();
        app.stage.addChild(game);
        await game.initialize(app);
        
        console.log('Game initialized!');
    } catch (error) {
        console.error('Error initializing game:', error);
        loadingText.text = 'Error loading game';
    }
}

// Start the game
init();
