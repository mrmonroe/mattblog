import Link from 'next/link'
import { getPost, getPosts } from '@/lib/posts'
import { formatDate } from '@/lib/utils'
import { notFound } from 'next/navigation'

export async function generateStaticParams() {
  const posts = await getPosts()
  return posts.map((post) => ({
    slug: post.slug,
  }))
}

export default async function PostPage({ params }: { params: { slug: string } }) {
  const post = await getPost(params.slug)

  if (!post) {
    notFound()
  }

  return (
    <>
      <nav className="top-navbar">
        <div className="nav-container">
          <h1 className="nav-title">
            <Link href="/">Matt's Blog</Link>
          </h1>
          <div className="nav-links">
            <Link href="/" className="nav-link">Blog</Link>
          </div>
        </div>
      </nav>
      
      <div className="container">
        <main role="main" className="mb-20">
          <article>
            <header>
              <h1 className="text-6xl font-light mb-8 text-gray-800">{post.title}</h1>
              <div className="post-meta mb-12" aria-label="Post metadata">
                <time dateTime={post.date}>{formatDate(post.date)}</time>
                <span> • </span>
                <span>By {post.author}</span>
              </div>
            </header>
            <div
              className="prose prose-lg max-w-none prose-headings:font-light prose-p:text-gray-600 prose-p:font-light prose-a:text-gray-800 prose-a:no-underline prose-a:hover:text-gray-600"
              dangerouslySetInnerHTML={{ __html: post.content }}
            />
          </article>
        </main>
        <footer>
          <Link href="/" className="btn btn-secondary">
            ← Back to Blog
          </Link>
        </footer>
      </div>
    </>
  )
}
