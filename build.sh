#!/bin/bash


echo "🧹 Cleaning project..."
flutter clean


echo "📦 Getting dependencies..."
flutter pub get


echo "🤖 Building Android App Bundle..."
flutter build appbundle --release


echo "🍏 Installing iOS pods..."
cd ios
pod install
cd ..


echo "🍏 Building iOS..."
flutter build ios --release


echo "✅ Build completed!"