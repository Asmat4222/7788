import Link from 'next/link';
import { Trophy } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-gray-400 mt-20">
      <div className="max-w-7xl mx-auto px-4 py-12 grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <div className="flex items-center gap-2 text-white font-bold text-lg mb-3">
            <Trophy className="w-5 h-5 text-green-400" />
            TennisCoach
          </div>
          <p className="text-sm">Find and book professional tennis coaches near you.</p>
        </div>
        <div>
          <h4 className="text-white font-semibold mb-3">Platform</h4>
          <ul className="space-y-2 text-sm">
            <li><Link href="/coaches" className="hover:text-white transition-colors">Find Coaches</Link></li>
            <li><Link href="/register" className="hover:text-white transition-colors">Become a Coach</Link></li>
          </ul>
        </div>
        <div>
          <h4 className="text-white font-semibold mb-3">Support</h4>
          <ul className="space-y-2 text-sm">
            <li><Link href="#" className="hover:text-white transition-colors">Help Center</Link></li>
            <li><Link href="#" className="hover:text-white transition-colors">Contact Us</Link></li>
          </ul>
        </div>
        <div>
          <h4 className="text-white font-semibold mb-3">Legal</h4>
          <ul className="space-y-2 text-sm">
            <li><Link href="#" className="hover:text-white transition-colors">Privacy Policy</Link></li>
            <li><Link href="#" className="hover:text-white transition-colors">Terms of Service</Link></li>
          </ul>
        </div>
      </div>
      <div className="border-t border-gray-800 text-center py-4 text-sm">
        © {new Date().getFullYear()} TennisCoach Marketplace. All rights reserved.
      </div>
    </footer>
  );
}
