import './globals.css';
import { Inter } from 'next/font/google';
import Providers from './providers';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import { Toaster } from 'react-hot-toast';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'TennisCoach - Find Your Perfect Tennis Coach',
  description: 'Book professional tennis coaches near you. Browse profiles, check availability, and book sessions instantly.',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={`${inter.className} bg-gray-50 min-h-screen`}>
        <Providers>
          <Navbar />
          <main>{children}</main>
          <Footer />
          <Toaster position="top-right" />
        </Providers>
      </body>
    </html>
  );
}
