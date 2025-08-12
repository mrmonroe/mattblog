# 🚀 Matt's Blog CLI

A powerful command-line application for managing your blog content, editorial calendar, and publishing workflow.

## ✨ Features

### 📝 **Editorial Management**
- **Content Planning**: Track ideas from concept to publication
- **Status Workflow**: 6-stage editorial process (Idea → Outline → Draft → Review → Ready → Published)
- **Priority System**: Low/Medium/High priority classification
- **Categories**: Organize content by themes (Design, Life, Technology)
- **Target Dates**: Set publication goals
- **Notes**: Capture research and key points

### 📚 **Blog Post Management**
- **Create Posts**: Generate new blog posts with proper front matter
- **Status Control**: Toggle between published and draft
- **Content Overview**: List all posts with status and metadata
- **Slug Generation**: Automatic URL-friendly slug creation

### 📊 **Analytics & Insights**
- **Content Statistics**: Overview of editorial items and blog posts
- **Status Breakdown**: Visual pipeline representation
- **Progress Tracking**: Monitor development stages

## 🚀 Quick Start

### Installation

#### Option 1: Global Install (Recommended)
```bash
# From the project directory
npm install -g .

# Or use the installation script
./install-cli.sh
```

#### Option 2: Manual Setup
```bash
# Make the CLI executable
chmod +x bin/mattblog

# Create a symlink to make it available globally
sudo ln -s $(pwd)/bin/mattblog /usr/local/bin/mattblog
```

### Usage

#### Interactive Mode (Full Menu System)
```bash
mattblog
```

#### Command Mode (Direct Actions)
```bash
# Editorial
mattblog add          # Add new item
mattblog list         # List all items
mattblog update       # Update status
mattblog delete       # Delete item

# Blog Posts
mattblog create       # Create new post
mattblog posts        # List all posts
mattblog toggle       # Toggle published status

# Information
mattblog stats        # Show statistics
mattblog help         # Show help
```

## 📋 Available Commands

### Editorial Management
| Command | Description |
|---------|-------------|
| `add` | Add new editorial item |
| `list` | List all editorial items |
| `update` | Update item status |
| `delete` | Delete editorial item |

### Blog Post Management
| Command | Description |
|---------|-------------|
| `create` | Create new blog post |
| `posts` | List all blog posts |
| `toggle` | Toggle post published status |

### Information
| Command | Description |
|---------|-------------|
| `stats` | Show content statistics |
| `help` | Show help message |

## 🎯 Editorial Workflow

```
Idea → Outline → Draft → Review → Ready → Published
  ↓        ↓       ↓       ↓       ↓        ↓
  💡      📋      ✍️      👀      ✅      🌐
```

### Status Descriptions
- **💡 Idea**: Initial content concept
- **📋 Outline**: Structured content plan
- **✍️ Draft**: Content creation in progress
- **👀 Review**: Content under review/editing
- **✅ Ready**: Content ready for publication
- **🌐 Published**: Content live on the blog

## 📁 Data Storage

- **Editorial Items**: Stored in `.editorial.json` (local file)
- **Blog Posts**: Stored in `posts/` directory as Markdown files
- **No Database Required**: Everything is file-based for simplicity

## 🎨 Interactive Interface

### Main Menu
```
🎯 Main Menu
──────────────────────────────
1. Editorial Management
2. Blog Post Management
3. View Statistics
4. Help
5. Exit
```

### Editorial Management Menu
```
📝 Editorial Management
──────────────────────────────
1. Add new item
2. List all items
3. Update status
4. Delete item
5. Back to main menu
```

### Blog Post Management Menu
```
📚 Blog Post Management
──────────────────────────────
1. Create new post
2. List all posts
3. Toggle published status
4. Back to main menu
```

## 💡 Usage Examples

### Adding an Editorial Item
```bash
mattblog add
```
**Interactive prompts:**
- Title: "The Art of Minimalism"
- Category: "Design"
- Target Date: "2024-02-15"
- Priority: "high"
- Notes: "Explore how less design can create more impact"

### Creating a Blog Post
```bash
mattblog create
```
**Interactive prompts:**
- Title: "Why Typography Matters"
- Excerpt: "Exploring the importance of good typography in web design"
- Date: "2024-01-20"
- Author: "Matt"
- Published: "n" (creates as draft)

### Quick Status Check
```bash
mattblog stats
```
**Shows:**
- Editorial item counts by status
- Priority breakdown
- Blog post counts (published vs drafts)
- Recent published posts

## 🔧 Configuration

### File Structure
```
mattblog/
├── bin/
│   └── mattblog          # CLI executable
├── install-cli.sh        # Installation script
├── .editorial.json       # Editorial data (auto-created)
├── posts/                # Blog posts directory
│   ├── post-1.md
│   ├── post-2.md
│   └── ...
└── package.json          # Project configuration
```

### Environment
- **Node.js**: Required (built-in modules only)
- **Dependencies**: Uses `gray-matter` for Markdown parsing
- **Permissions**: CLI file is executable
- **Global Access**: Available as `mattblog` command from anywhere

## 🎨 Customization

### Adding New Statuses
Edit the `bin/mattblog` file and update the `statuses` array in the `updateItemStatus` function.

### Modifying Priority Levels
Update the `priorityColors` object in the `listEditorialItems` function.

### Changing Default Values
Modify the `EditorialItem` constructor or form prompts as needed.

## 🚨 Error Handling

- **File Operations**: Graceful handling of read/write errors
- **User Input**: Validation for required fields
- **Graceful Exit**: Ctrl+C handling and cleanup
- **Data Integrity**: Backup and validation of editorial data

## 🔄 Workflow Integration

### Daily Content Management
1. **Morning**: Check editorial calendar (`mattblog list`)
2. **Planning**: Add new ideas (`mattblog add`)
3. **Writing**: Update status as you progress (`mattblog update`)
4. **Review**: Check statistics (`mattblog stats`)

### Publishing Workflow
1. **Create Post**: `mattblog create`
2. **Write Content**: Edit the generated Markdown file
3. **Publish**: `mattblog toggle` to change status
4. **Verify**: Check blog to ensure post appears

## 💻 Keyboard Shortcuts

- **Ctrl+C**: Exit the application
- **Enter**: Confirm input
- **Arrow Keys**: Navigate menus (when supported)

## 🆘 Troubleshooting

### Common Issues
- **Permission Denied**: Ensure `bin/mattblog` is executable (`chmod +x bin/mattblog`)
- **Command Not Found**: Reinstall globally with `npm install -g .`
- **File Not Found**: Check that you're in the project directory
- **Data Corruption**: Delete `.editorial.json` to reset (backup first)

### Getting Help
```bash
mattblog help
```

## 🚀 Advanced Usage

### Scripting
```bash
# Create multiple posts
echo "Post 1" | mattblog create
echo "Post 2" | mattblog create

# Batch status updates
for status in idea outline draft; do
  mattblog update
done
```

### Integration
- **Git Hooks**: Use in pre-commit hooks to validate content
- **CI/CD**: Integrate with deployment pipelines
- **Automation**: Schedule regular content reviews

## 📈 Best Practices

### Content Planning
- Set realistic target dates
- Use categories consistently
- Prioritize based on audience needs
- Keep notes detailed and actionable

### Workflow Management
- Update status regularly as you work
- Use the statistics to identify bottlenecks
- Maintain a balance of content types
- Review and clean up old items periodically

### File Management
- Use descriptive titles for easy identification
- Keep editorial items organized by priority
- Regular backups of `.editorial.json`
- Clean up completed items

## 🎉 Getting Started Checklist

- [ ] Install dependencies (`npm install`)
- [ ] Install CLI globally (`npm install -g .`)
- [ ] Test CLI command (`mattblog help`)
- [ ] Check statistics (`mattblog stats`)
- [ ] Add your first editorial item (`mattblog add`)
- [ ] Create your first blog post (`mattblog create`)
- [ ] Explore interactive mode (`mattblog`)

## 🔄 Migration from Old CLI

If you were using the old `npm run cli` command:

1. **Install new CLI**: `npm install -g .`
2. **Replace commands**:
   - `npm run cli` → `mattblog`
   - `npm run cli add` → `mattblog add`
   - `npm run cli stats` → `mattblog stats`
3. **Remove old script**: The `cli` script in package.json is no longer needed

---

**Ready to take control of your content?** 🚀

Start with `mattblog help` and begin building your editorial empire from the command line!
