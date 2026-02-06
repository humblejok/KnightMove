# Knight Move

A chess knight puzzle game where you control a knight piece that must collect blobs while avoiding breaking all the board tiles.

## About

This game was originally written in ActionScript 3 using the Starling framework and has been **converted to JavaScript using PixiJS** (Starling's spiritual successor for the web).

## Game Rules

- Control a chess knight on an 8x4 board
- The knight moves automatically in L-shaped patterns (like in chess)
- Click/tap on a valid square to choose the knight's next move
- Collect the pink blob to score 100 points
- Each tile can be stepped on 3 times before it breaks
- Stepping on broken tiles ends the game
- Collecting a blob repairs all tiles and increases game speed
- Try to achieve the highest score!

## Technology

### Original (ActionScript)
- **Language**: ActionScript 3
- **Framework**: Starling (Flash-based 2D framework)
- **Platform**: Flash Player / Adobe AIR
- **Total Code**: ~817 lines

### Converted (JavaScript)
- **Language**: JavaScript (ES6+)
- **Framework**: PixiJS 7.3 (WebGL-based 2D framework)
- **Platform**: Modern web browsers
- **Build Tool**: Vite
- **Total Code**: ~700 lines

## Key Conversions

| ActionScript Concept | JavaScript Equivalent |
|---------------------|---------------------|
| `Starling.core.Starling` | `PIXI.Application` |
| `starling.display.Sprite` | `PIXI.Container` / `PIXI.Sprite` |
| `starling.display.Image` | `PIXI.Sprite` |
| `starling.display.MovieClip` | `PIXI.AnimatedSprite` |
| `starling.display.Button` | `PIXI.Sprite` with `interactive = true` |
| `starling.text.TextField` | `PIXI.Text` |
| `starling.events.TouchEvent` | PixiJS pointer events |
| `flash.utils.getTimer()` | `Date.now()` |
| `[Embed]` assets | Dynamic asset loading with `PIXI.Assets` |
| XML texture atlases | XML parsing + manual atlas creation |

## Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Development

The game will automatically open in your browser at `http://localhost:3000` when running the dev server.

## Project Structure

```
KnightMove/
├── src/
│   ├── js/
│   │   ├── element/          # Game element classes
│   │   │   ├── Element.js           # Base element class
│   │   │   ├── KnightElement.js     # Knight piece
│   │   │   ├── BlobElement.js       # Collectible blob
│   │   │   ├── TargetElement.js     # Target indicator
│   │   │   └── BoardElement.js      # Board tile
│   │   ├── sprites/          # Game sprite classes
│   │   │   ├── Game.js              # Main game container
│   │   │   ├── Board.js             # Game board & logic
│   │   │   └── BoardSprite.js       # Animated board tile
│   │   ├── utils/            # Utility classes
│   │   │   └── AssetsProvider.js    # Asset loading & management
│   │   └── main.js           # Application entry point
├── assets/                    # Game assets (images, sprites)
├── index.html                # HTML entry point
├── package.json              # Dependencies
└── vite.config.js            # Build configuration
```

## Browser Support

Works in all modern browsers that support WebGL:
- Chrome 56+
- Firefox 51+
- Safari 11+
- Edge 79+

## License

MIT

## Credits

Original ActionScript version by humblejok
Converted to JavaScript/PixiJS by GitHub Copilot
