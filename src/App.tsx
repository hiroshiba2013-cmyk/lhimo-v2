// build: 20260510-v4
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { LanguageProvider } from './contexts/LanguageContext';
import { Header } from './components/layout/Header';
import { Footer } from './components/layout/Footer';
import { Router } from './components/Router';
import { CookieBanner } from './components/common/CookieBanner';
import { ToastProvider } from './components/common/Toast';

function AppContent() {
  const { user, profile } = useAuth();
  const isAdmin = profile?.user_type === 'admin';
  const path = window.location.pathname;
  const isAdminPage = path.startsWith('/admin') || path === '/admin-login' || path === '/admin-secure-register-2024';

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Header />
      <div className="flex-1">
        <Router key={user ? `authenticated-${user.id}` : 'unauthenticated'} />
      </div>
      {!isAdminPage && <Footer />}
      <CookieBanner />
    </div>
  );
}

function App() {
  return (
    <LanguageProvider>
      <AuthProvider>
        <ToastProvider>
          <AppContent />
        </ToastProvider>
      </AuthProvider>
    </LanguageProvider>
  );
}

export default App;
