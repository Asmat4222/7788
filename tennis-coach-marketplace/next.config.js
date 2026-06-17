/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['ui-avatars.com', 'images.unsplash.com'],
    remotePatterns: [
      { protocol: 'https', hostname: '**' },
    ],
  },
};

module.exports = nextConfig;
