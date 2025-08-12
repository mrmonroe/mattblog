# 📝 Blog Post Templates

Professional templates for consistent, high-quality blog posts. Each template follows best practices for structure, SEO, and reader engagement.

## 🎯 **Available Templates**

### 1. **Standard Blog Post** (`standard-post.md`)
- **Best for**: General articles, insights, and educational content
- **Structure**: Introduction → Main content → Conclusion
- **Features**: SEO-optimized front matter, clear sections, call-to-action

### 2. **How-To Tutorial** (`how-to-tutorial.md`)
- **Best for**: Step-by-step guides and instructional content
- **Structure**: Prerequisites → Steps → Testing → Troubleshooting
- **Features**: Clear prerequisites, numbered steps, pro tips, common issues

### 3. **Thought Leadership** (`thought-leadership.md`)
- **Best for**: Opinion pieces, industry insights, and expert perspectives
- **Structure**: Problem → Perspective → Implications → Action
- **Features**: Strong thesis, supporting arguments, actionable insights

### 4. **Case Study** (`case-study.md`)
- **Best for**: Analyzing real-world examples and extracting lessons
- **Structure**: Background → Approach → Results → Analysis → Lessons
- **Features**: Executive summary, quantitative results, actionable insights

### 5. **Quick Update** (`quick-update.md`)
- **Best for**: News, announcements, and brief insights
- **Structure**: What → Why → Details → Take → Next
- **Features**: Concise format, quick action items, minimal reading time

## 🚀 **Using Templates**

### **Via CLI**
```bash
# Create post with specific template
mattblog create --template standard-post

# List available templates
mattblog templates
```

### **Manual Usage**
1. Copy the desired template file
2. Rename to your post slug
3. Fill in the placeholders (text in brackets)
4. Customize content for your topic
5. Update front matter as needed

## 📋 **Template Features**

### **Front Matter Standards**
- `title`: SEO-optimized, compelling headline
- `excerpt`: One-sentence description for social sharing
- `date`: Publication date (YYYY-MM-DD)
- `author`: Your name or pen name
- `published`: Boolean for draft/published status
- `tags`: Array of relevant keywords
- `category`: Main content category
- `readingTime`: Estimated reading time
- `featured`: Boolean for featured post status

### **Content Structure**
- **Clear hierarchy** with consistent heading levels
- **Scannable content** with bullet points and lists
- **Actionable insights** and practical takeaways
- **Engagement elements** like questions and calls-to-action
- **SEO optimization** with proper heading structure

### **Best Practices**
- **Hook readers** with compelling introductions
- **Break up text** with subheadings and lists
- **Include examples** to illustrate concepts
- **End with action** or thought-provoking questions
- **Link to related content** for engagement

## 🔧 **Customization**

### **Adding New Templates**
1. Create new `.md` file in `templates/` directory
2. Follow existing structure and naming conventions
3. Include comprehensive front matter
4. Add to this README with description

### **Modifying Existing Templates**
- Keep the core structure intact
- Update placeholders as needed
- Maintain consistent formatting
- Test with different content types

## 📊 **Template Selection Guide**

| Content Type | Template | Reading Time | Complexity |
|--------------|----------|--------------|------------|
| General article | Standard Post | 5 min | Medium |
| Step-by-step guide | How-To Tutorial | 8 min | High |
| Industry insight | Thought Leadership | 6 min | Medium |
| Success analysis | Case Study | 10 min | High |
| News/update | Quick Update | 2 min | Low |

## 💡 **Pro Tips**

1. **Choose the right template** for your content type
2. **Customize placeholders** before writing content
3. **Maintain consistency** across similar post types
4. **Update front matter** based on your specific needs
5. **Test templates** with different topics and audiences

---

**Need help with a template?** Use `mattblog help` or check the main documentation.
