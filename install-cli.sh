#!/bin/bash

# Matt's Blog CLI Installation Script
echo "🚀 Installing Matt's Blog CLI..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

# Install the CLI globally
echo "📦 Installing CLI globally..."
npm install -g .

if [ $? -eq 0 ]; then
    echo "✅ CLI installed successfully!"
    echo ""
    echo "🎯 You can now use:"
    echo "   mattblog          # Interactive mode"
    echo "   mattblog help     # Show help"
    echo "   mattblog stats    # Show statistics"
    echo "   mattblog add      # Add editorial item"
    echo "   mattblog create   # Create blog post"
    echo ""
    echo "💡 Try: mattblog help"
else
    echo "❌ Installation failed. Please check the error messages above."
    exit 1
fi
