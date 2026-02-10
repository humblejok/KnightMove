import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.humblejok.knightmove',
  appName: 'Knight Move',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: '#000000',
      showSpinner: false,
    },
    StatusBar: {
      style: 'dark',
      backgroundColor: '#000000'
    }
  },
  android: {
    // Keep screen on during gameplay
    allowMixedContent: true,
    backgroundColor: '#000000'
  }
};

export default config;
