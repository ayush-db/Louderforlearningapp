import { LogOut, Bell, Shield, HelpCircle, ChevronRight, Mail, School, BookOpen, Edit3 } from 'lucide-react';
import { BottomNav, Tab } from './BottomNav';

interface Props {
  name: string;
  email: string;
  schoolLevel: string;
  subjects: string[];
  onLogout: () => void;
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

const levelLabels: Record<string, string> = {
  elementary: 'Elementary (K–5)',
  middle: 'Middle School (6–8)',
  high: 'High School (9–12)',
  special: 'Special Education',
  cte: 'Career & Technical',
};

const subjectLabels: Record<string, string> = {
  math: 'Math', science: 'Science', english: 'English', arts: 'Arts',
  history: 'History', physed: 'Physical Ed', music: 'Music',
  technology: 'Technology', social: 'Social Studies', foreign: 'Foreign Language',
};

function Row({ icon: Icon, label, value, danger }: { icon: React.ElementType; label: string; value?: string; danger?: boolean }) {
  return (
    <div
      className="flex items-center gap-3.5 px-4 py-3.5"
      style={{ borderBottom: '1px solid #F5F5F5' }}
    >
      <div
        className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0"
        style={{ background: danger ? '#FEF2F2' : '#F3F4F6' }}
      >
        <Icon size={17} color={danger ? '#DC2626' : '#6B7280'} />
      </div>
      <div className="flex-1">
        <p style={{ fontSize: '14px', fontWeight: 500, color: danger ? '#DC2626' : '#111827' }}>{label}</p>
        {value && <p style={{ fontSize: '12px', color: '#9CA3AF', marginTop: '1px' }}>{value}</p>}
      </div>
      {!danger && <ChevronRight size={16} color="#D1D5DB" />}
    </div>
  );
}

export function MyAccount({ name, email, schoolLevel, subjects, onLogout, activeTab, onTabChange }: Props) {
  const initials = name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase();
  const resolvedSubjects = subjects.map(s => subjectLabels[s] ?? s);

  return (
    <div className="flex flex-col h-full bg-gray-50">
      <div className="flex-1 overflow-y-auto pb-24">
        {/* Header */}
        <div
          className="px-5 pt-14 pb-8 flex flex-col items-center"
          style={{ background: 'linear-gradient(160deg, #134F34 0%, #1B7A50 100%)' }}
        >
          {/* Avatar */}
          <div
            className="w-20 h-20 rounded-full flex items-center justify-center mb-4"
            style={{ background: 'rgba(255,255,255,0.2)', border: '3px solid rgba(255,255,255,0.35)' }}
          >
            <span style={{ color: '#fff', fontWeight: 800, fontSize: '28px', lineHeight: 1 }}>{initials}</span>
          </div>
          <p style={{ fontSize: '20px', fontWeight: 700, color: '#fff' }}>{name}</p>
          <p style={{ fontSize: '13px', color: 'rgba(255,255,255,0.65)', marginTop: '3px' }}>{email}</p>
          <button
            className="mt-4 flex items-center gap-1.5 px-4 py-1.5 rounded-full"
            style={{ background: 'rgba(255,255,255,0.15)', border: '1px solid rgba(255,255,255,0.25)' }}
          >
            <Edit3 size={12} color="rgba(255,255,255,0.85)" />
            <span style={{ fontSize: '12px', color: 'rgba(255,255,255,0.85)', fontWeight: 500 }}>Edit Profile</span>
          </button>
        </div>

        {/* Teacher Profile Summary */}
        <div className="px-5 py-4">
          <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF', marginBottom: '12px' }}>
            YOUR TEACHER PROFILE
          </p>
          <div className="bg-white rounded-2xl overflow-hidden" style={{ border: '1px solid #F0F0F0' }}>
            <div className="flex items-start gap-3.5 px-4 py-4" style={{ borderBottom: '1px solid #F5F5F5' }}>
              <div className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0" style={{ background: '#EBF6F0' }}>
                <School size={17} color="#1B7A50" />
              </div>
              <div>
                <p style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 500 }}>School Level</p>
                <p style={{ fontSize: '14px', fontWeight: 600, color: '#111827', marginTop: '1px' }}>
                  {schoolLevel ? levelLabels[schoolLevel] ?? schoolLevel : 'Not set'}
                </p>
              </div>
            </div>
            <div className="flex items-start gap-3.5 px-4 py-4">
              <div className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0" style={{ background: '#EBF6F0' }}>
                <BookOpen size={17} color="#1B7A50" />
              </div>
              <div>
                <p style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 500 }}>Subjects</p>
                {resolvedSubjects.length > 0 ? (
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {resolvedSubjects.map(s => (
                      <span
                        key={s}
                        className="px-2.5 py-0.5 rounded-full"
                        style={{ fontSize: '12px', fontWeight: 500, background: '#EBF6F0', color: '#1B7A50', border: '1px solid #C8E6D4' }}
                      >
                        {s}
                      </span>
                    ))}
                  </div>
                ) : (
                  <p style={{ fontSize: '14px', fontWeight: 600, color: '#111827', marginTop: '1px' }}>Not set</p>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Account settings */}
        <div className="px-5 py-2">
          <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF', marginBottom: '12px' }}>
            ACCOUNT
          </p>
          <div className="bg-white rounded-2xl overflow-hidden" style={{ border: '1px solid #F0F0F0' }}>
            <Row icon={Mail} label="Email" value={email} />
            <Row icon={Bell} label="Notifications" value="Grants, deadlines, status updates" />
            <Row icon={Shield} label="Privacy & Security" />
            <Row icon={HelpCircle} label="Help & Support" />
          </div>
        </div>

        {/* Logout */}
        <div className="px-5 pt-4 pb-2">
          <button
            onClick={onLogout}
            className="w-full bg-white rounded-2xl overflow-hidden transition-all active:scale-[0.98]"
            style={{ border: '1px solid #F0F0F0' }}
          >
            <div className="flex items-center gap-3.5 px-4 py-3.5">
              <div className="w-9 h-9 rounded-xl flex items-center justify-center" style={{ background: '#FEF2F2' }}>
                <LogOut size={17} color="#DC2626" />
              </div>
              <p style={{ fontSize: '14px', fontWeight: 600, color: '#DC2626' }}>Sign Out</p>
            </div>
          </button>
        </div>

        <p className="text-center mt-4 mb-2" style={{ fontSize: '11px', color: '#D1D5DB' }}>
          Louder for Learning · v1.0.0
        </p>
      </div>

      <BottomNav activeTab={activeTab} onTabChange={onTabChange} />
    </div>
  );
}
