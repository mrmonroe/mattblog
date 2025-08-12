#!/bin/bash

# Setup Remote Git Repository Script
echo "🚀 Setting up remote Git repository for Matt's Blog..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Please run 'git init' first."
    exit 1
fi

# Get the current remote
current_remote=$(git remote get-url origin 2>/dev/null)

if [ -n "$current_remote" ]; then
    echo "✅ Remote origin already exists: $current_remote"
    echo "🔄 To change it, run: git remote set-url origin <new-url>"
else
    echo "📝 No remote origin found."
    echo ""
    echo "🔧 To add a remote repository:"
    echo "   1. Create a new repository on GitHub/GitLab/etc."
    echo "   2. Copy the repository URL"
    echo "   3. Run: git remote add origin <repository-url>"
    echo ""
    echo "💡 Example:"
    echo "   git remote add origin https://github.com/username/mattblog.git"
    echo ""
    echo "🚀 After adding the remote, push with:"
    echo "   git push -u origin main"
fi

echo ""
echo "📊 Current Git status:"
git status --short

echo ""
echo "🌿 Current branch: $(git branch --show-current)"
echo "🔗 Current remotes:"
git remote -v
