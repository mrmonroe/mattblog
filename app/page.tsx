import Link from 'next/link'
import { getPosts } from '@/lib/posts'
import { formatDate } from '@/lib/utils'

export default async function Home() {
  const posts = await getPosts()

  return (
    <>
      <nav className="top-navbar">
        <div className="nav-container">
          <h1 className="nav-title">
            <Link href="/">Matt's Blog</Link>
          </h1>
          <div className="nav-links">
            <Link href="/" className="nav-link active" aria-current="page">Blog</Link>
          </div>
        </div>
      </nav>
      
      <div className="container">
        <main role="main">
          <section aria-label="Blog posts">
            {posts.map((post) => (
              <article key={post.slug} className="post">
                <header>
                  <h2 className="text-4xl font-light mb-6">
                    <Link href={`/post/${post.slug}`} className="text-gray-800 hover:text-gray-600 transition-colors">
                      {post.title}
                    </Link>
                  </h2>
                  <div className="post-meta mb-6" aria-label="Post metadata">
                    <time dateTime={post.date}>{formatDate(post.date)}</time>
                    <span> • </span>
                    <span>By {post.author}</span>
                  </div>
                </header>
                <p className="post-excerpt">A brief introduction to this space where I share thoughts, ideas, and stories.</p>
              </article>
            ))}
          </section>
        </main>
      </div>
    </>
  )
}
