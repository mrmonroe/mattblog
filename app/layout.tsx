import type { Metadata, Viewport } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: "Matt's Blog",
  description: 'A minimal blog focused on thoughts, ideas, and stories with clean typography and white space',
  keywords: ['blog', 'minimal', 'typography', 'writing', 'thoughts'],
  authors: [{ name: 'Matt' }],
  openGraph: {
    title: "Matt's Blog",
    description: 'A minimal blog focused on thoughts, ideas, and stories with clean typography and white space',
    type: 'website',
  },
  twitter: {
    card: 'summary',
    title: "Matt's Blog",
    description: 'A minimal blog focused on thoughts, ideas, and stories with clean typography and white space',
  },
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body suppressHydrationWarning={true}>{children}</body>
    </html>
  )
}
