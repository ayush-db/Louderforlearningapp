import { useState } from 'react';
import { Eye, EyeOff, Mail, Lock, ArrowRight, AlertCircle } from 'lucide-react';

interface Props {
  onLogin: (name: string, email: string) => void;
}

type Mode = 'login' | 'signup';

export function LoginScreen({ onLogin }: Props) {
  const [mode, setMode] = useState<Mode>('login');
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  function handleSubmit() {
    setError('');
    if (!email.trim() || !password.trim()) {
      setError('Please fill in all fields.');
      return;
    }
    if (mode === 'signup' && !name.trim()) {
      setError('Please enter your name.');
      return;
    }
    if (!email.includes('@')) {
      setError('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setError('Password must be at least 6 characters.');
      return;
    }
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      onLogin(mode === 'signup' ? name : '', email);
    }, 900);
  }

  return (
    <div className="flex flex-col h-full bg-white overflow-y-auto">
      {/* Top brand strip */}
      <div
        className="px-5 pt-14 pb-10 flex flex-col items-center"
        style={{ background: 'linear-gradient(160deg, #134F34 0%, #1B7A50 100%)' }}
      >
        <div
          className="w-16 h-16 rounded-2xl flex items-center justify-center mb-4"
          style={{ background: 'rgba(255,255,255,0.15)', border: '2px solid rgba(255,255,255,0.25)' }}
        >
          <span style={{ color: '#fff', fontWeight: 900, fontSize: '30px', lineHeight: 1 }}>L</span>
        </div>
        <p style={{ fontSize: '20px', fontWeight: 800, color: '#fff', letterSpacing: '-0.3px' }}>
          Louder for Learning
        </p>
        <p style={{ fontSize: '13px', color: 'rgba(255,255,255,0.65)', marginTop: '4px' }}>
          Grants for Underfunded Schools
        </p>
      </div>

      {/* Card */}
      <div className="flex-1 px-5 -mt-5">
        <div
          className="rounded-3xl p-6 bg-white"
          style={{ boxShadow: '0 4px 24px rgba(0,0,0,0.10)', border: '1px solid #F0F0F0' }}
        >
          {/* Mode toggle */}
          <div
            className="flex mb-6 rounded-xl overflow-hidden"
            style={{ background: '#F3F4F6' }}
          >
            {(['login', 'signup'] as Mode[]).map(m => (
              <button
                key={m}
                onClick={() => { setMode(m); setError(''); }}
                className="flex-1 py-2.5 transition-all"
                style={{
                  background: mode === m ? '#1B7A50' : 'transparent',
                  color: mode === m ? '#fff' : '#6B7280',
                  fontWeight: 600,
                  fontSize: '14px',
                  borderRadius: '10px',
                }}
              >
                {m === 'login' ? 'Sign In' : 'Create Account'}
              </button>
            ))}
          </div>

          <h2 className="text-gray-900 mb-1" style={{ fontSize: '22px', fontWeight: 700 }}>
            {mode === 'login' ? 'Welcome back.' : 'Join the community.'}
          </h2>
          <p style={{ fontSize: '13px', color: '#6B7280', marginBottom: '24px' }}>
            {mode === 'login'
              ? 'Sign in to access your grant opportunities.'
              : 'Create your free teacher account today.'}
          </p>

          <div className="flex flex-col gap-4">
            {/* Name field (signup only) */}
            {mode === 'signup' && (
              <div>
                <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
                  FULL NAME
                </label>
                <div
                  className="flex items-center gap-3 mt-1.5 px-4 py-3 rounded-xl"
                  style={{ border: '1.5px solid #E5E7EB', background: '#FAFAFA' }}
                >
                  <input
                    type="text"
                    placeholder="Sarah Davis"
                    value={name}
                    onChange={e => setName(e.target.value)}
                    className="flex-1 bg-transparent outline-none"
                    style={{ fontSize: '15px', color: '#111827' }}
                  />
                </div>
              </div>
            )}

            {/* Email */}
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
                EMAIL ADDRESS
              </label>
              <div
                className="flex items-center gap-3 mt-1.5 px-4 py-3 rounded-xl"
                style={{ border: '1.5px solid #E5E7EB', background: '#FAFAFA' }}
              >
                <Mail size={16} color="#9CA3AF" />
                <input
                  type="email"
                  placeholder="you@school.edu"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  className="flex-1 bg-transparent outline-none"
                  style={{ fontSize: '15px', color: '#111827' }}
                />
              </div>
            </div>

            {/* Password */}
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
                PASSWORD
              </label>
              <div
                className="flex items-center gap-3 mt-1.5 px-4 py-3 rounded-xl"
                style={{ border: '1.5px solid #E5E7EB', background: '#FAFAFA' }}
              >
                <Lock size={16} color="#9CA3AF" />
                <input
                  type={showPass ? 'text' : 'password'}
                  placeholder={mode === 'login' ? '••••••••' : 'Min. 6 characters'}
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  className="flex-1 bg-transparent outline-none"
                  style={{ fontSize: '15px', color: '#111827' }}
                  onKeyDown={e => e.key === 'Enter' && handleSubmit()}
                />
                <button onClick={() => setShowPass(s => !s)}>
                  {showPass
                    ? <EyeOff size={16} color="#9CA3AF" />
                    : <Eye size={16} color="#9CA3AF" />}
                </button>
              </div>
            </div>
          </div>

          {/* Error */}
          {error && (
            <div
              className="flex items-center gap-2 mt-4 p-3 rounded-xl"
              style={{ background: '#FEF2F2', border: '1px solid #FECACA' }}
            >
              <AlertCircle size={14} color="#DC2626" />
              <p style={{ fontSize: '13px', color: '#DC2626' }}>{error}</p>
            </div>
          )}

          {/* Forgot password */}
          {mode === 'login' && (
            <div className="flex justify-end mt-3">
              <button style={{ fontSize: '13px', color: '#1B7A50', fontWeight: 500 }}>
                Forgot password?
              </button>
            </div>
          )}

          {/* Submit */}
          <button
            onClick={handleSubmit}
            disabled={loading}
            className="w-full mt-6 py-4 rounded-2xl flex items-center justify-center gap-2 transition-all active:scale-[0.98]"
            style={{
              background: loading ? '#4D9E72' : '#1B7A50',
              color: '#fff',
              fontWeight: 700,
              fontSize: '16px',
            }}
          >
            {loading ? (
              <span>Signing in…</span>
            ) : (
              <>
                {mode === 'login' ? 'Sign In' : 'Create Account'}
                <ArrowRight size={18} />
              </>
            )}
          </button>
        </div>

        {/* Bottom note */}
        <p className="text-center mt-6 mb-8" style={{ fontSize: '12px', color: '#9CA3AF', lineHeight: 1.6 }}>
          By continuing, you agree to our{' '}
          <span style={{ color: '#1B7A50', fontWeight: 500 }}>Terms of Service</span>{' '}
          and{' '}
          <span style={{ color: '#1B7A50', fontWeight: 500 }}>Privacy Policy</span>.
        </p>
      </div>
    </div>
  );
}
