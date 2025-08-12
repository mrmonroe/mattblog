# 🚀 Matt's Blog

A beautiful, minimal blog built with Next.js 14, focusing on perfect typography and white space. Features a powerful CLI for content management.

## ✨ Features

### 🌐 **Blog**
- **Minimal Design**: Clean, Zen Habits-inspired aesthetic
- **Perfect Typography**: Optimized for readability
- **Responsive Layout**: Works beautifully on all devices
- **Markdown Support**: Write content in Markdown
- **SEO Optimized**: Semantic HTML and metadata

### 📝 **Content Management CLI**
- **Global Command**: `mattblog` available from anywhere
- **Editorial Workflow**: 6-stage content pipeline
- **Priority Management**: Low/Medium/High classification
- **Content Creation**: Generate posts with proper front matter
- **Status Control**: Toggle between published and draft

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd mattblog
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Install CLI globally**
   ```bash
   npm install -g .
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

5. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 📚 Using the CLI

### Interactive Mode
```bash
mattblog
```

### Command Mode
```bash
# Editorial Management
mattblog add          # Add new editorial item
mattblog list         # List all items
mattblog update       # Update item status
mattblog delete       # Delete item

# Blog Post Management
mattblog create       # Create new blog post
mattblog posts        # List all posts
mattblog toggle       # Toggle published status

# Information
mattblog stats        # Show content statistics
mattblog help         # Show help
```

### Editorial Workflow
```
Idea → Outline → Draft → Review → Ready → Published
```

## 📁 Project Structure

```
mattblog/
├── app/                    # Next.js App Router
│   ├── globals.css        # Global styles
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Homepage
│   └── post/[slug]/       # Blog post pages
├── bin/
│   └── mattblog           # CLI executable
├── lib/                    # Utility functions
│   ├── posts.ts           # Post management
│   └── utils.ts           # Helper functions
├── posts/                  # Markdown blog posts
├── public/                 # Static assets
├── .gitignore             # Git ignore rules
├── CLI_README.md          # Detailed CLI documentation
├── install-cli.sh         # CLI installation script
├── next.config.js         # Next.js configuration
├── package.json           # Dependencies and scripts
├── postcss.config.js      # PostCSS configuration
├── tailwind.config.ts     # Tailwind CSS configuration
└── tsconfig.json          # TypeScript configuration
```

## 🎨 Design Philosophy

### Typography
- **Font**: Light weight fonts for elegance
- **Spacing**: Generous white space for readability
- **Hierarchy**: Clear visual hierarchy with proper contrast

### Colors
- **Palette**: Greyscale only for minimalism
- **Links**: No underlines, subtle hover effects
- **Background**: Clean white with subtle borders

### Layout
- **Width**: Optimized for reading (max-width: 42rem)
- **Spacing**: Consistent margins and padding
- **Responsive**: Mobile-first design approach

## 📝 Content Management

### Creating Posts
1. **Use CLI**: `mattblog create`
2. **Edit Markdown**: Write content in the generated file
3. **Set Status**: Use `mattblog toggle` to publish

### Post Front Matter
```markdown
---
title: "Your Post Title"
excerpt: "Brief description"
date: "2024-01-20"
author: "Matt"
published: true
---

Your content here...
```

### Editorial Planning
- **Track Ideas**: Use `mattblog add` for content planning
- **Set Priorities**: Low/Medium/High classification
- **Monitor Progress**: Check status with `mattblog stats`

## 🛠️ Development

### Available Scripts
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

### Tech Stack
- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS with custom components
- **Content**: Markdown with gray-matter parsing
- **CLI**: Node.js with readline interface

### Configuration Files
- **Next.js**: `next.config.js`
- **TypeScript**: `tsconfig.json`
- **Tailwind**: `tailwind.config.ts`
- **PostCSS**: `postcss.config.js`

## 🚀 Deployment

### Vercel (Recommended)
1. Connect your GitHub repository
2. Vercel will auto-detect Next.js
3. Deploy with zero configuration

### Other Platforms
- **Netlify**: Supports Next.js with build commands
- **Railway**: Easy deployment with Git integration
- **Self-hosted**: Build and deploy to your server

## 🔧 Customization

### Styling
- Modify `app/globals.css` for custom styles
- Update `tailwind.config.ts` for theme changes
- Add new components in the `app` directory

### CLI
- Edit `bin/mattblog` for CLI modifications
- Add new commands in the switch statement
- Customize colors and formatting

### Content
- Modify post templates in the CLI
- Add new front matter fields
- Customize the editorial workflow

## 📊 Analytics & Insights

### Content Statistics
- Editorial item counts by status
- Blog post counts (published vs drafts)
- Priority breakdown
- Recent published posts

### Workflow Monitoring
- Track content through stages
- Identify bottlenecks
- Monitor publishing frequency

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

### Common Issues
- **CLI not found**: Reinstall with `npm install -g .`
- **Build errors**: Check TypeScript and Next.js versions
- **Styling issues**: Verify Tailwind CSS configuration

### Getting Help
- Check the [CLI_README.md](CLI_README.md) for detailed CLI usage
- Review Next.js documentation for framework issues
- Open an issue for bugs or feature requests

---

**Ready to start blogging?** 🚀

Visit [http://localhost:3000](http://localhost:3000) to see your blog, and use `mattblog help` to learn about content management!
