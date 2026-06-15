import { useState } from 'react';
import { LoginScreen } from './components/LoginScreen';
import { OnboardingStep1 } from './components/OnboardingStep1';
import { OnboardingStep2 } from './components/OnboardingStep2';
import { Dashboard } from './components/Dashboard';
import { GrantDetails } from './components/GrantDetails';
import { ApplicationForm } from './components/ApplicationForm';
import { ApplicationStatus } from './components/ApplicationStatus';
import { TeacherSpotlight } from './components/TeacherSpotlight';
import { MyAccount } from './components/MyAccount';
import { Tab } from './components/BottomNav';

type Screen =
  | 'login'
  | 'onboarding1'
  | 'onboarding2'
  | 'dashboard'
  | 'grant-detail'
  | 'apply'
  | 'status'
  | 'teacher-spotlight'
  | 'account';

export default function App() {
  const [screen, setScreen] = useState<Screen>('login');
  const [teacherName, setTeacherName] = useState('');
  const [teacherEmail, setTeacherEmail] = useState('');
  const [schoolLevel, setSchoolLevel] = useState('');
  const [subjects, setSubjects] = useState<string[]>([]);
  const [selectedGrantId, setSelectedGrantId] = useState('1');
  const [activeTab, setActiveTab] = useState<Tab>('grants');
  const [isFirstLogin, setIsFirstLogin] = useState(true);

  function handleLogin(name: string, email: string) {
    setTeacherName(name);
    setTeacherEmail(email);
    if (isFirstLogin) {
      setScreen('onboarding1');
    } else {
      setActiveTab('grants');
      setScreen('dashboard');
    }
  }

  function handleLogout() {
    setTeacherName('');
    setTeacherEmail('');
    setSchoolLevel('');
    setSubjects([]);
    setIsFirstLogin(true);
    setScreen('login');
  }

  function toggleSubject(s: string) {
    setSubjects(prev => prev.includes(s) ? prev.filter(x => x !== s) : [...prev, s]);
  }

  function handleTabChange(tab: Tab) {
    setActiveTab(tab);
    if (tab === 'apply') setScreen('apply');
    else if (tab === 'status') setScreen('status');
    else if (tab === 'account') setScreen('account');
    else setScreen('dashboard');
  }

  return (
    <div
      className="flex items-start justify-center min-h-screen w-full"
      style={{ background: '#E8EDF2' }}
    >
      <div
        className="relative overflow-hidden bg-white"
        style={{ width: '100%', maxWidth: 430, minHeight: '100vh', height: '100vh', display: 'flex', flexDirection: 'column' }}
      >
        {screen === 'login' && (
          <LoginScreen onLogin={handleLogin} />
        )}

        {screen === 'onboarding1' && (
          <OnboardingStep1
            selected={schoolLevel}
            onSelect={setSchoolLevel}
            onNext={() => setScreen('onboarding2')}
          />
        )}

        {screen === 'onboarding2' && (
          <OnboardingStep2
            selected={subjects}
            onToggle={toggleSubject}
            onFinish={() => { setIsFirstLogin(false); setActiveTab('grants'); setScreen('dashboard'); }}
            onBack={() => setScreen('onboarding1')}
          />
        )}

        {screen === 'dashboard' && (
          <Dashboard
            teacherName={teacherName}
            schoolLevel={schoolLevel}
            subjects={subjects}
            onGrantSelect={id => { setSelectedGrantId(id); setScreen('grant-detail'); }}
            onTeacherSpotlight={() => setScreen('teacher-spotlight')}
            onAccountPress={() => { setActiveTab('account'); setScreen('account'); }}
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}

        {screen === 'grant-detail' && (
          <GrantDetails
            grantId={selectedGrantId}
            onBack={() => setScreen('dashboard')}
            onApply={id => { setSelectedGrantId(id); setActiveTab('apply'); setScreen('apply'); }}
          />
        )}

        {screen === 'apply' && (
          <ApplicationForm
            grantId={selectedGrantId}
            onBack={() => setScreen('grant-detail')}
            onSubmit={() => { setActiveTab('status'); setScreen('status'); }}
          />
        )}

        {screen === 'status' && (
          <ApplicationStatus
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}

        {screen === 'teacher-spotlight' && (
          <TeacherSpotlight onBack={() => setScreen('dashboard')} />
        )}

        {screen === 'account' && (
          <MyAccount
            name={teacherName}
            email={teacherEmail}
            schoolLevel={schoolLevel}
            subjects={subjects}
            onLogout={handleLogout}
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}
      </div>
    </div>
  );
}
