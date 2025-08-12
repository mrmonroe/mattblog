import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import { remark } from 'remark'
import html from 'remark-html'

const postsDirectory = path.join(process.cwd(), 'posts')

export interface Post {
  slug: string
  title: string
  excerpt: string
  content: string
  date: string
  author: string
  published: boolean
}

export async function getPosts(): Promise<Post[]> {
  // Ensure posts directory exists
  if (!fs.existsSync(postsDirectory)) {
    fs.mkdirSync(postsDirectory, { recursive: true })
    
    // Create sample posts if directory is empty
    const samplePosts = [
      {
        slug: 'welcome-post',
        title: 'Welcome to My Blog',
        excerpt: 'A brief introduction to this space where I share thoughts, ideas, and stories.',
        content: `# Welcome to My Blog

This is the beginning of something wonderful. Here I'll share my thoughts, ideas, and stories in a space designed for clarity and focus.

## What to Expect

- Thoughts on design and typography
- Personal reflections and experiences
- Ideas worth sharing

Stay tuned for more content coming soon.`,
        date: '2024-01-15',
        author: 'Matt',
        published: true
      },
      {
        slug: 'typography-matters',
        title: 'Why Typography Matters',
        excerpt: 'Exploring the importance of good typography in web design and how it affects readability.',
        content: `# Why Typography Matters

Typography is more than just choosing fonts. It's about creating a reading experience that guides the eye and enhances understanding.

## The Impact of Good Typography

Good typography can:
- Improve readability
- Enhance user experience
- Convey professionalism
- Guide user attention

## Principles to Follow

1. **Hierarchy**: Use size and weight to create clear information hierarchy
2. **Contrast**: Ensure sufficient contrast between text and background
3. **Spacing**: Give text room to breathe with proper line height and margins
4. **Consistency**: Maintain consistent typography throughout your design

Typography is the foundation of good design. When done well, it becomes invisible, allowing the content to shine.`,
        date: '2024-01-10',
        author: 'Matt',
        published: true
      }
    ]

    // Write sample posts to files
    samplePosts.forEach(post => {
      const filePath = path.join(postsDirectory, `${post.slug}.md`)
      const frontMatter = `---
title: "${post.title}"
excerpt: "${post.excerpt}"
date: "${post.date}"
author: "${post.author}"
published: ${post.published}
---

${post.content}`
      
      fs.writeFileSync(filePath, frontMatter)
    })
  }

  // Get all posts from the posts directory
  const fileNames = fs.readdirSync(postsDirectory)
  const allPosts = fileNames
    .filter(fileName => fileName.endsWith('.md'))
    .map(fileName => {
      // Remove ".md" from file name to get slug
      const slug = fileName.replace(/\.md$/, '')

      // Read markdown file as string
      const fullPath = path.join(postsDirectory, fileName)
      const fileContents = fs.readFileSync(fullPath, 'utf8')

      // Use gray-matter to parse the post metadata section
      const matterResult = matter(fileContents)

      // Combine the data with the slug
      return {
        slug,
        title: matterResult.data.title || 'Untitled',
        excerpt: matterResult.data.excerpt || '',
        content: matterResult.data.content || matterResult.content,
        date: matterResult.data.date || new Date().toISOString().split('T')[0],
        author: matterResult.data.author || 'Unknown',
        published: matterResult.data.published !== false // Default to true if not specified
      }
    })

  // Filter to only show published posts
  const publishedPosts = allPosts.filter(post => post.published)

  // Sort posts by date (newest first)
  return publishedPosts.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())
}

export async function getPost(slug: string): Promise<Post | null> {
  try {
    const fullPath = path.join(postsDirectory, `${slug}.md`)
    const fileContents = fs.readFileSync(fullPath, 'utf8')

    // Use gray-matter to parse the post metadata section
    const matterResult = matter(fileContents)

    // Combine the data with the slug
    const post: Post = {
      slug,
      title: matterResult.data.title || 'Untitled',
      excerpt: matterResult.data.excerpt || '',
      content: matterResult.data.content || matterResult.content,
      date: matterResult.data.date || new Date().toISOString().split('T')[0],
      author: matterResult.data.author || 'Unknown',
      published: matterResult.data.published !== false // Default to true if not specified
    }

    // Only return published posts
    if (!post.published) {
      return null
    }

    // Use remark to convert markdown into HTML string
    const processedContent = await remark()
      .use(html)
      .process(matterResult.content)
    const contentHtml = processedContent.toString()

    return {
      ...post,
      content: contentHtml,
    }
  } catch (error) {
    console.error(`Error reading post ${slug}:`, error)
    return null
  }
}
