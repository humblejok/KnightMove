import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { SplashScreen } from '@capacitor/splash-screen';

/**
 * Initialize mobile-specific features for Android/iOS
 * This should be called early in the app initialization
 */
export async function initializeMobile() {
    if (!Capacitor.isNativePlatform()) {
        console.log('Running in web browser - skipping mobile initialization');
        return;
    }

    console.log('Initializing mobile platform:', Capacitor.getPlatform());

    try {
        // Hide status bar for fullscreen game experience
        await StatusBar.setStyle({ style: Style.Dark });
        await StatusBar.setBackgroundColor({ color: '#000000' });
        
        // On Android, we can hide the status bar completely
        if (Capacitor.getPlatform() === 'android') {
            await StatusBar.hide();
        }
    } catch (error) {
        console.warn('StatusBar configuration error:', error);
    }

    try {
        // Hide splash screen once the app is ready
        await SplashScreen.hide();
    } catch (error) {
        console.warn('SplashScreen hide error:', error);
    }

    // Prevent the screen from sleeping during gameplay
    if ('wakeLock' in navigator) {
        try {
            const wakeLock = await navigator.wakeLock.request('screen');
            console.log('Wake Lock acquired');
            
            // Re-acquire wake lock if visibility changes
            document.addEventListener('visibilitychange', async () => {
                if (document.visibilityState === 'visible') {
                    await navigator.wakeLock.request('screen');
                }
            });
        } catch (error) {
            console.warn('Wake Lock error:', error);
        }
    }

    // Handle Android back button
    document.addEventListener('backbutton', (event) => {
        event.preventDefault();
        // Could show a "confirm exit" dialog here
        console.log('Back button pressed');
    });

    console.log('Mobile initialization complete');
}

/**
 * Check if running on a native mobile platform
 */
export function isMobile() {
    return Capacitor.isNativePlatform();
}

/**
 * Get the current platform name
 */
export function getPlatform() {
    return Capacitor.getPlatform();
}
